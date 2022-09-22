//
//  CookiesTransition.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

class CookiesCoordinator {
    let root  : UINavigationController
    private let scene      = BehaviorSubject<CookiesScene>(value: .home)
    private let disposeBag = DisposeBag()
    
    init(root: UINavigationController) {
        self.root = root
        self.setBind()
    }
    
    func execute(to scene: CookiesScene) {
        self.scene.onNext(scene)
    }
}

extension CookiesCoordinator {
    private func setBind() {
        self.scene
            .subscribe(onNext: { [weak self] scene in
                let vc = scene.viewController
                vc.coordinator = self
                
                switch scene {
                case .home:
                    self?.root.setViewControllers([vc], animated: true)
                case .madeList:
                    self?.root.present(vc, animated: true)
                    
                case .coollectList:
                    self?.root.present(vc, animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
}
