//
//  CKRootViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

class CKRootViewController: UINavigationController, CookieEmbeddable {
    var coordinator: CookiesCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coordinator = CookiesCoordinator(root: self)
    }
}
