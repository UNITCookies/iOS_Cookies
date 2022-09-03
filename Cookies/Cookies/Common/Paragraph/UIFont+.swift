//
//  UIFont+.swift
//  Cookies
//
//  Created by Kim HeeJae on 2022/09/03.
//

import UIKit

extension UIFont {

    @nonobjc class var title1: UIFont{
        PretendardSemiBold(size: 30)
    }

    @nonobjc class var title2: UIFont{
        PretendardSemiBold(size: 20)
    }

    @nonobjc class var text1: UIFont{
        PretendardRegular(size: 14)
    }

    @nonobjc class var text2: UIFont{
        PretendardLight(size: 14)
    }

    @nonobjc class var pop1: UIFont{
        PretendardSemiBold(size: 20)
    }

    @nonobjc class var pop2: UIFont{
        PretendardRegular(size: 10)
    }
    
    // Basic
    class func PretendardLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Light", size: size)!
    }

    class func PretendardRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size)!
    }

    class func PretendardSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size)!
    }
}
