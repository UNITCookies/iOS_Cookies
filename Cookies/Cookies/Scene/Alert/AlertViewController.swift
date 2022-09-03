//
//  WriteViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

class AlertViewController: UIViewController {
    private let transitioning = TransitioningDelegate()
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deniedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBind()
    }
}

extension AlertViewController {
    func setBind() {
        self.deniedButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: self.disposeBag)
    }
}

extension AlertViewController: VCFactorable {
    public static var storyboardIdentifier = "Alert"
    public static var vcIdentifier = "AlertViewController"
    public func bindData(value: ()) {
        self.transitioning.present.willPresent = { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 0.0
            self.bottomConst.constant = -300
            self.view.layoutIfNeeded()
        }
        
        self.transitioning.present.didPresnet = { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 1.0
            self.bottomConst.constant = 0
        }
        
        self.transitioning.dismiss.willDismiss = { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        self.transitioning.dismiss.didDismiss = { [weak self] in
            guard let self = self else { return }
            self.bottomConst.constant = -300
            self.view.alpha = 0.0
        }
        
        self.transitioningDelegate  = self.transitioning
        self.modalPresentationStyle = .overCurrentContext
    }
}
