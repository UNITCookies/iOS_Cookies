//
//  UIView+.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

extension UIApplication {
    public static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets , safeAreaInsets.top > 20 {
                return safeAreaInsets
            }
            return .zero
        }
        return .zero
    }
}
