//
//  GuideViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

class GuideViewController: UIViewController {
    private let transitioning = TransitioningDelegate()
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var dropCookieButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBind()
    }
}

extension GuideViewController {
    private func setBind() {
        self.skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: self.disposeBag)
        
        self.dropCookieButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = AlertViewController.createInstance(())
                self?.present(vc, animated: true)
            }).disposed(by: self.disposeBag)
    }
}

extension GuideViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier = "GuideViewController"
    public func bindData(value: ()) {
        self.transitioning.present.willPresent = { [weak self] in
            self?.backView.alpha = 0.0
            self?.view.layoutIfNeeded()
        }
        
        self.transitioning.present.didPresnet = { [weak self] in
            guard let self = self else { return }
            self.backView.alpha = 0.5
        }
        
        
        self.transitioning.dismiss.willDismiss = { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        self.transitioning.dismiss.didDismiss = { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 0.0
        }
        
        self.transitioningDelegate  = self.transitioning
        self.modalPresentationStyle = .overCurrentContext
    }
}
