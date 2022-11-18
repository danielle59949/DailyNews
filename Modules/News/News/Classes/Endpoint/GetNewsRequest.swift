//
//  GetNewsRequest.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import Helper
import Constant
import Alamofire

class GetNewsRequest: BaseRequest {
    typealias Response = ArticleResponse
    
    private var page: Int
    private var pageSize: Int
    
    init(page: Int, pageSize: Int) {
        self.page = page
        self.pageSize = pageSize
    }
    
    var domain = UrlConstant.kNewsHost
    
    var path = "v2/top-headlines"
    
    var header: HTTPHeaders?
    
    var params: Parameters? {
        return [
            "apiKey": UrlConstant.kApiKey,
            "country": "us",
            "page": page,
            "pageSize": pageSize
        ]
    }
    
    var method: HTTPMethod = .get
    
    var encoding: ParameterEncoding = URLEncoding.default
}
