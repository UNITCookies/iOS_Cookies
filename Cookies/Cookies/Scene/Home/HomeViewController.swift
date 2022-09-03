//
//  HomeViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var menuContainerView: UIView!
    @IBOutlet private weak var mapContainerView: UIView!
    
    
    private let disposeBag = DisposeBag()
    private let menuView    = BottomMenuView.loadView()
    private lazy var naverMap: NMFMapView = NMFMapView(frame: self.view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.presentGuideView()
        self.setBind()
    }
}

extension HomeViewController {
    private func setViews() {
        self.menuContainerView.addSubview(self.menuView)
        self.mapContainerView.addSubview(self.naverMap)
        self.menuView.fillSuperview()
    }
    
    private func presentGuideView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let guideView = GuideViewController.createInstance(())
            self.present(guideView, animated: true)
        }
    }
}

extension HomeViewController {
    private func setBind() {
        self.menuView.rx.tappedWrite
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else { return .empty() }
                let messageView = WriteView.loadView()
                return AlertViewController.createInstance(messageView)
                    .getStream(WithPresenter: self, presentationStyle: .overCurrentContext)
                    .filter { $0 }
                    .map { _ in messageView.message }
            }
            .subscribe(onNext: { [weak self] message in
                print("message: \(message)")
//                let vc = AlertViewController.createInstance(())
//                self?.present(vc, animated: true)
            }).disposed(by: self.disposeBag)
    }
}

extension HomeViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier = "HomeViewController"
    public func bindData(value: ()) {
        
    }
}
