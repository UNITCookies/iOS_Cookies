//
//  Model.Pin.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/04.
//

import Foundation

extension Model {
    struct Pin: Codable {
        let disablePin: [Model.Pin.Cookie]
        let enablePin : [Model.Pin.Cookie]
        
        enum CodingKeys: String, CodingKey {
            case disablePin  = "all"
            case enablePin   = "radius"
        }
    }
}

extension Model.Pin {
    struct Cookie: Codable {
        let id : String
        let lat: Double
        let lng: Double
        let enableCount: Int
        
        enum CodingKeys: String, CodingKey {
            case id  = "letterId"
            case lat = "x"
            case lng = "y"
            case enableCount = "enableCount"
        }
    }
}
