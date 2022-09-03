//
//  Model.Letter.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import Foundation

extension Model {
    struct Letter: Codable {
        let content    : String
        let nickname   : String
        let lat        : Double
        let lng        : Double
        let enableCount: Int
        
        enum CodingKeys: String, CodingKey {
            case content  = "letterContent"
            case nickname = "letterNickname"
            case lat = "x"
            case lng = "y"
            case enableCount = "enableCount"
        }
    }
}
