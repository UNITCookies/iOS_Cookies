//
//  API.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift
import RxCocoa
import Alamofire

let USER_ID = "ca25625d-3282-4b55-8a20-4fed6d1179d4"

extension API {
    struct ReadLetter {
        let id: String
    }
}

extension API.ReadLetter: APIConfigWithError {
    static let domainConfig = CookieDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "http://43.200.232.27:8080/letter/\(self.id)?userId=\(USER_ID)" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return nil
    }
    
    func parse(_ input: Data) throws -> Model.Letter {
        let json   = try? input.toDict()
        let result = (json?["result"] as? [String: Any])!
        return try Model.Letter.decode(dictionary: result)
    }
}
