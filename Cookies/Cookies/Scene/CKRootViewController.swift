//
//  CKRootViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

class CKRootViewController: UINavigationController, CookieEmbeddable {
    var transition: CookiesTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transition = CookiesTransition(root: self)
    }
}
