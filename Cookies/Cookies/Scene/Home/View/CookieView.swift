//
//  CookieView.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

class CookieView: UIView {
    static func loadView() -> CookieView {
        return Bundle.main.loadNibNamed(CookieView.className, owner: self, options: nil)?.first as! CookieView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
