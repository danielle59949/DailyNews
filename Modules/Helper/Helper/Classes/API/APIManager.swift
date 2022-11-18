//
//  APIManager.swift
//  Helper
//
//  Created by Daniel Le on 18/11/2022.
//

import Alamofire

class APIManager {
    static let shared: APIManager = {
        return APIManager(session: Session.default)
    }()
    
    var session: Session
    
    init(session: Session) {
        self.session = session
    }
}
