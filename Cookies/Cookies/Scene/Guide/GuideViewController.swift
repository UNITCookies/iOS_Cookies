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
    @IBOutlet private weak var explainLabel: UILabel!
    
    private let dismissTrigger = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipButton.titleLabel?.font = .text1
        skipButton.setTitle("다음에 할까요...?", for: .normal)
        skipButton.setTitleColor(.sub, for: .normal)

        explainLabel.text = "쿠키를 눌러 메세지를 남겨보세요!"
        explainLabel.font = .text1
        explainLabel.textColor = .white
        
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
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else { return .empty() }
                let messageView = WriteView.loadView()
                return AlertViewController.createInstance((contentView: messageView,
                                                           leftButtonTitle: nil,
                                                           rightButtonTitle: "쿠키 작성 완료"))
                    .getStream(WithPresenter: self,
                               presentationStyle: .overCurrentContext)
                    .filter { $0 }
                    .map { _ in messageView.message
                    }
            }
            .subscribe(onNext: { [weak self] message in
                self?.dismiss(animated: true,
                              completion: {
                    self?.dismissTrigger.onNext(message)
                })
            }).disposed(by: self.disposeBag)
    }
}

extension GuideViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier = "GuideViewController"
    public func bindData(value: PublishSubject<String>) {
        self.dismissTrigger
            .bind(to: value)
            .disposed(by: self.disposeBag)
        
        self.transitioning.present.willPresent = { [weak self] in
            self?.backView.alpha = 0.0
            self?.view.layoutIfNeeded()
        }
        
        self.transitioning.present.didPresnet = { [weak self] in
            guard let self = self else { return }
            self.backView.alpha = 1.0
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
