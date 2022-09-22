//
//  CookiesScene.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

enum CookiesScene {
    case home
    case madeList
    case coollectList
}

extension CookiesScene {
    init(scene: CookiesScene) {
        self = scene
    }
    
    var viewController: CKBaseViewController {
        switch self {
        case .home:
            let vc: HomeViewController = HomeViewController.createInstance(())
            return vc
        case .madeList:
            let vc: CookieListViewController = CookieListViewController()
            return vc
        case .coollectList:
            let vc: CookieListViewController = CookieListViewController()
            return vc
        }
    }
}
