//
//  API.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift
import RxCocoa
import Alamofire

let USER_ID = "3e330fcb-2015-44b7-8558-3c62f8ccabea"

extension API {
    struct ReadLetter {
        let id: String
    }
    
    struct CookiesPin {
        let userLat: Double
        let userLng: Double
        let topLeftLat: Double
        let topLeftLng: Double
        let bottomRightLat: Double
        let bottomRightLng: Double
    }
//http://43.200.232.27:8080/letter/write?memberId={memberId}
    struct WriteLetter {
        let content: String
        let lat: Double
        let lng: Double
    }
}

extension API.ReadLetter: APIConfigWithError {
    static let domainConfig = CookieDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/letter/\(self.id)?memberId=\(USER_ID)" }
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

extension API.CookiesPin: APIConfigWithError {
    static let domainConfig = CookieDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/letter/map" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        let params: [String: Any] = ["curMemberX": self.userLat,
                                     "curMemberY": self.userLng,
                                     "startX"    : self.topLeftLat,
                                     "startY"    : self.topLeftLng,
                                     "endX"      : self.bottomRightLat,
                                     "endY"      : self.bottomRightLng
        ]
        
        return .map(params)
    }
    
    func parse(_ input: Data) throws -> Model.Pin {
        let json   = try? input.toDict()
        let result = (json?["result"] as? [String: Any])!
        return try Model.Pin.decode(dictionary: result)
    }
}

extension API.WriteLetter: APIConfigWithError {
    static let domainConfig = CookieDomain.self
    static let serviceError = MockError.self
    var path: String { return "/letter/write?memberId=\(USER_ID)" }
    var method: HTTPMethod { return .post }
    var parameters: API.Parameter? {
        let params: [String: Any] = ["letterContent":self.content,
                                     "x":self.lat,
                                     "y":self.lng]
        return .map(params)
    }
    
    func parse(_ input: Data) throws -> Bool {
        let json   = try? input.toDict()
        let result = (json?["isSuccess"] as? Bool)!
        return result
    }
}

/*
 {
     "letterContent" : "안녕하세요!! 안녕하세요!! 안녕하세요!! 안녕하세요!! 안녕하세요!! 안녕하세요!! 안녕하세요!! 안녕하세요!! 안녕하세요!! 안녕하세요!!",
     "x" : 37.4952339,
     "y" : 127.0382079
 }
 */
