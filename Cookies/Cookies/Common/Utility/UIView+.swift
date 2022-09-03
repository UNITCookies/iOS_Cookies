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

extension UIView {
    public  func cornerRadius(_ corners: UIRectCorner, radius: CGFloat) {
         _ = _round(corners, radius: radius)
     }
    
    fileprivate func _round(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
}
