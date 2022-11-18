//
//  SearchNewsRequest.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import Helper
import Constant
import Alamofire

class SearchNewsRequest: BaseRequest {
    typealias Response = ArticleResponse
    
    private var keyword: String
    private var page: Int
    private var pageSize: Int
    
    init(keyword: String, page: Int, pageSize: Int) {
        self.keyword = keyword
        self.page = page
        self.pageSize = pageSize
    }
    
    var domain = UrlConstant.kNewsHost
    
    var path = "v2/everything"
    
    var header: HTTPHeaders?
    
    var params: Parameters? {
        return [
            "apiKey": UrlConstant.kApiKey,
            "page": page,
            "pageSize": pageSize,
            "q": keyword
        ]
    }
    
    var method: HTTPMethod = .get
    
    var encoding: ParameterEncoding = URLEncoding.default
}
