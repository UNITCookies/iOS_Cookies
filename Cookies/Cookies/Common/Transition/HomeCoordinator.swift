//
//  HomeCoordinator.swift
//  Cookies
//
//  Created by Haehyeon Jeong on 2022/10/29.
//

import UIKit
import RxSwift

extension Scene {
    enum Home: Sceneable {
        case home
        case madeList
        case collectList
        
        var viewController: CKBaseViewController {
            switch self {
            case .home:
                let vc: HomeViewController = HomeViewController.createInstance(())
                vc.reactor = HomeReactor(service: APIService())
                return vc
            case .madeList:
                return CookieListViewController()
            case .collectList:
                return CookieListViewController()
            }
        }
    }
}

final class HomeCoordinator: Coordinatorable {
    let root: RootContainerable
    var childs: [any Coordinatorable] = []
    private let scene      = BehaviorSubject<Scene.Home>(value: .home)
    private let disposeBag = DisposeBag()
    
    init(root: RootContainerable) {
        self.root = root
        self.setBind()
    }
    
    func start() {
        self.execute(to: .home)
    }
    
    func execute(to scene: Scene.Home) {
        self.scene.onNext(scene)
    }
}


extension HomeCoordinator {
    func setBind() {
        self.scene
            .subscribe(with: self) { owner, scene in
                switch scene {
                case .home: break
//                    let vc = HomeContainerViewController.createInstance(())
//                    owner.root.setViewControllers([vc], animated: true)
//                    owner.root.present(scene.viewController, animated: false)
                case .madeList: break
                case .collectList: break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func backToRoot(prevScene: CKBaseViewController) {
    }
}
