//
//  APIError.Code.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import Foundation

extension APIError {
    public enum Code: Int, Codable {
        case http = -9999
        case serviceExternalUnavailable
        case internalServerError
        case networkError
        case inconsistantModelParseFailed
        case opertaionCanceled
        case unknownError
        case malformedRequest
        case globalException
    }
}
