//
//  CookieDomain.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import Alamofire

struct CookieDomain: DomainConfig {
    static let domain: String = ""
    static let manager: Alamofire.Session = {
        return Alamofire.Session(configuration: .default)
    }()
    
    static var defaultHeader: [String : String]? {
        return ["Accept":"application/json"]
    }
    
    static var parameters: [String : Any?]? {
        return nil
    }
}
