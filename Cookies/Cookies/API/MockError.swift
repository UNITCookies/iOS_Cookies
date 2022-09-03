//
//  APIError.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import Foundation

public struct MockError: ServiceErrorable {
    public let code: MockError.Code
    public let message: String?
    
    public static func globalException() -> Bool {
        return false
    }
}

extension MockError {
    public enum Code: Int, ServiceErrorCodeRawPresentable {
        case unknownError
    }
}
