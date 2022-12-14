//
//  WriteViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class AlertViewController: UIViewController {
    private let transitioning = TransitioningDelegate()
    private let disposeBag = DisposeBag()
    var completion: ((Bool) -> ())!
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var bottomConst: NSLayoutConstraint!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet private weak var shadowView: UIView!
    
    private let leftButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .main
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    private let rightButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.sub, for: .normal)
        btn.backgroundColor = .main
        btn.titleLabel?.font = .title2
        btn.layer.addBorder([.top, .bottom], color: UIColor.black, width: 1)
        return btn
    }()
    
    private var contentView: UIView?
    private var leftTitle: String?
    private var rightTItle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
}

extension AlertViewController {
    private func setupUI() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 0)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        
        
        if let rightTitle = self.rightTItle {
            self.rightButton.setTitle(rightTitle, for: .normal)
            self.buttonStackView.addArrangedSubview(self.rightButton)
            self.rightButton.snp.makeConstraints { $0.height.equalTo(70) }
            self.rightButton.layer.addBorder([.top, .bottom], color: UIColor.black, width: 1)
        }
        
        if let leftTitle = self.leftTitle {
            self.leftButton.setTitle(leftTitle, for: .normal)
            self.buttonStackView.addArrangedSubview(self.leftButton)
            self.leftButton.snp.makeConstraints { $0.height.equalTo(70) }
            self.leftButton.layer.addBorder([.top, .bottom], color: UIColor.black, width: 1)
        }
        
        self.alertView.layer.cornerRadius = 10.0
        self.alertView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.containerView.addSubview(self.contentView!)
        self.contentView?.fillSuperview()
        self.view.layoutIfNeeded()
    }
    
    private func setBind() {
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.completion(false)
                })
            }).disposed(by: self.disposeBag)
        
        self.rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.completion(true)
                })
            }).disposed(by: self.disposeBag)
        
        self.leftButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.completion(false)
                })
            }).disposed(by: self.disposeBag)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo! as [AnyHashable: Any]
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: duration , delay: 0, options: animationCurve, animations: {
            self.bottomConst.constant = (endFrame?.size.height ?? 0) - UIApplication.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
        })
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        let userInfo = notification.userInfo! as [AnyHashable: Any]
        _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: duration , delay: 0, options: animationCurve, animations: {
            self.bottomConst.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
          
        })
    }
}

extension AlertViewController: VCFactorable {
    public static var storyboardIdentifier = "Alert"
    public static var vcIdentifier = "AlertViewController"
    public func bindData(value: (contentView: UIView,
                                 leftButtonTitle: String?,
                                 rightButtonTitle: String?)) {
        
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
        
        self.contentView = value.contentView
        self.leftTitle   = value.leftButtonTitle
        self.rightTItle  = value.rightButtonTitle
    }
}

extension AlertViewController: Completable { }
