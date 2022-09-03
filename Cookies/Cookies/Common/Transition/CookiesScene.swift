//
//  CookiesScene.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

enum CookiesScene {
    case home
}

extension CookiesScene {
    init(scene: CookiesScene) {
        self = scene
    }
    
    var viewController: UIViewController {
        switch self {
        case .home:
            let vc: ViewController = ViewController.createInstance(())
            return vc
        }
    }
}
