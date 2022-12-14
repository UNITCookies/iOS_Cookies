//
//  CookieDomain.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import Alamofire

struct CookieDomain: DomainConfig {
    static let domain: String = "http://43.200.232.27:8080"
    static let manager: Alamofire.Session = {
        return Alamofire.Session(configuration: .default)
    }()
    
    static var defaultHeader: [String : String]? {
        return nil
    }
    
    static var parameters: [String : Any?]? {
        return nil
    }
}
