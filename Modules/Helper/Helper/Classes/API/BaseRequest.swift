//
//  BaseAPI.swift
//  Helper
//
//  Created by Daniel Le on 18/11/2022.
//

import Alamofire
import RxSwift
import RxCocoa
import Constant

struct PropertyKeys {
    static var RequestId = "RequestId"
}

public protocol CancelableRequest: AnyObject {
    var id: UUID? { get set }
    
    func cancel()
}

extension CancelableRequest {
    public var id: UUID? {
        get {
            return objc_getAssociatedObject(self, &PropertyKeys.RequestId) as? UUID
        } set {
            objc_setAssociatedObject(self, &PropertyKeys.RequestId, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public protocol BaseRequest: CancelableRequest {
    associatedtype Response: Decodable
    
    var domain: String { get }
    var path: String { get }
    var header: HTTPHeaders? { get }
    var params: Parameters? { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    
    func map(from data: Data) -> (Response?, Error?)
    func validateStatusCode(_ statusCode: Int) -> Error?
    func doRequest() -> Observable<Response>
}

extension BaseRequest {
    public func doRequest() -> Observable<Response> {
        let url = domain + path
        
        return Observable.create { observable in
            let request = APIManager.shared.session.request(
                url,
                method: self.method,
                parameters: self.params,
                encoding: self.encoding,
                headers: self.header
            )
            self.id = request.id
            
            request.responseData { [weak self] (response: AFDataResponse<Data>) in
                print(request.cURLDescription())
                guard let self = self else {
                    observable.onCompleted()
                    return
                }
                
                if let statusCode = response.response?.statusCode,
                   let error = self.validateStatusCode(statusCode) {
                    observable.onError(error)
                    observable.onCompleted()
                }
                
                switch response.result {
                case .success(let data):
                    let (object, error) = self.map(from: data)
                    if let object = object {
                        observable.onNext(object)
                    } else if let error = error {
                        observable.onError(error)
                    }
                case .failure(let error):
                    observable.onError(error)
                }
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    public func map(from data: Data) -> (Response?, Error?) {
        do {
            let object = try JSONDecoder().decode(Response.self, from: data)
            return (object, nil)
        } catch {
            return (nil, error)
        }
    }
    
    public func validateStatusCode(_ statusCode: Int) -> Error? {
        if [403, -1001].contains(statusCode) {
            return NSError(domain: "Timeout", code: -1001, userInfo: nil)
        }
        return nil
    }
    
    public func cancel() {
        APIManager.shared.session.withAllRequests { [weak self] requests in
            if let request = requests.first(where: { $0.id == self?.id }) {
                request.cancel()
            }
        }
    }
}
