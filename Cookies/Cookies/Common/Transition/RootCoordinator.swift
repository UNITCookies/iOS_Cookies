//
//  CookiesTransition.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

protocol Sceneable { }

struct Scene {
    enum Root: Sceneable {
        case home
        case guide
        
        var viewController: CKBaseViewController {
            switch self {
            case .home:
                let vc: HomeViewController = HomeViewController.createInstance(())
                vc.reactor = HomeReactor(service: APIService())
                return vc
            case .guide:
                let vc: GuideViewController = GuideViewController.createInstance(())
                return vc
            }
        }
    }
}

class RootCoordinator: Coordinatorable {
    let root  : RootContainerable
    var childs: [any Coordinatorable] = []
    private let scene      = PublishSubject<Scene.Root>()
    private let disposeBag = DisposeBag()
    
    init(root: RootContainerable) {
        self.root = root
        self.setBind()
    }
    
    func start() {
        self.execute(to: .home)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.execute(to: .guide)
        })
    }
    
    func execute(to scene: Scene.Root) {
        self.scene.onNext(scene)
    }
}

extension RootCoordinator {
    private func setBind() {
        self.scene
            .subscribe(with: self, onNext: { owner, scene in
                let vc = scene.viewController
                
                switch scene {
                case .home:
                    owner.root.naviViewController?.setViewControllers([vc], animated: true)
                case .guide:
                    guard let vc = vc as? GuideViewController else { return }
                    vc.delegate = self
                    owner.root.present(vc, animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
}

extension RootCoordinator: GuideViewControllerDelegate {
    func dismissGuide() {
        
    }
}
