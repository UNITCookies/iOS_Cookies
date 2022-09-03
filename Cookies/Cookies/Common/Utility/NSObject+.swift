//
//  NSObject+.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import Foundation

extension NSObject {
    
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return String(describing: type(of: self).className)
    }
}
