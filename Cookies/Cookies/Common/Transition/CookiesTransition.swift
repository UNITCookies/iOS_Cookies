//
//  CookiesTransition.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

class CookiesTransition {
    let root  : UINavigationController
    private let scene      = BehaviorSubject<CookiesScene>(value: .home)
    private let disposeBag = DisposeBag()
    
    init(root: UINavigationController) {
        self.root = root
        self.setBind()
    }
}

extension CookiesTransition {
    private func setBind() {
        self.scene
            .subscribe(onNext: { [weak self] scene in
                switch scene {
                case .home:
                    self?.root.setViewControllers([scene.viewController], animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
}
