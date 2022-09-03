//
//  API.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift
import RxCocoa
import Alamofire

extension API {
    struct TempService {
        let id: String
    }
}

extension API.TempService: APIConfigWithError {
    static let domainConfig = CookieDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "http://43.200.232.27:8080/member" }
    var method: HTTPMethod { return .post }
    var parameters: API.Parameter? {
        let params = [String:Any]()
        return .map(params)
    }
    
    func parse(_ input: Data) throws -> [Int] {
        return try input.parse()
    }
}
