//
//  Coordinator.swift
//  Cookies
//
//  Created by Haehyeon Jeong on 2022/10/31.
//

import UIKit

protocol SceneExcutable {
    associatedtype T: Sceneable
    func execute(to scene: T)
}

protocol Coordinatorable: AnyObject, SceneExcutable {
    var childs: [any Coordinatorable] { get set }
    var root  : RootContainerable { get }
    func start()
}

protocol RootContainerable where Self: UIViewController {
    var naviViewController: UINavigationController? { get }
}
