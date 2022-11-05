//
//  CKRootViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

protocol CKRootViewControllerCoordinatorDelegate: AnyObject {
    func didTapCollectList()
    func didTapMadeList()
}

final class CKRootViewController: UIViewController, CookieEmbeddable, RootContainerable {
    
    @IBOutlet private weak var tabBarBottomView: UIView!
    @IBOutlet private weak var tabBar: UIView!
    var coordinator: RootCoordinator?
    weak var delegate: CKRootViewControllerCoordinatorDelegate?
    
    let naviViewController: UINavigationController? = {
        let nav = UINavigationController()
        return nav
    }()
    
    private let menuView   = BottomMenuView.loadView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navi = self.naviViewController {
            self.show(navi)
        }
        self.coordinator = RootCoordinator(root: self)
        self.coordinator?.start()
        self.setupUI()
        self.setBind()
    }
    
    private func setupUI () {
        self.view.bringSubviewToFront(self.tabBarBottomView)
        self.view.bringSubviewToFront(self.tabBar)
        self.tabBar.addSubview(self.menuView)
        self.menuView.fillSuperview()
    }
    
    private func setBind() {
        self.menuView.rx.tappedShowMadeList
            .subscribe(with: self) { owner, _ in
                owner.delegate?.didTapMadeList()
            }
            .disposed(by: self.disposeBag)
        
        self.menuView.rx.tappedShowCollectedList
            .subscribe(with: self) { owner, _ in
                owner.delegate?.didTapCollectList()
            }
            .disposed(by: self.disposeBag)
        
        self.menuView.rx.tappedWrite
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else { return .empty() }
                let messageView = WriteView.loadView()
                return AlertViewController.createInstance((contentView: messageView,
                                                           leftButtonTitle: nil,
                                                           rightButtonTitle: "쿠키 작성 완료"))
                    .getStream(WithPresenter: self, presentationStyle: .overCurrentContext)
                    .filter { $0 }
                    .map { _ in messageView.message }
            }.subscribe(onNext: { _ in
                
            }).disposed(by: self.disposeBag)
    }
}

extension CKRootViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier         = "CKRootViewController"
    public func bindData(value: ()) {
        
    }
}
