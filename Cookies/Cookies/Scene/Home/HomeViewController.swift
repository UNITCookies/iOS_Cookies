//
//  HomeViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    @IBOutlet public weak var infoViewBottomConst: NSLayoutConstraint!
    @IBOutlet private weak var cookiesView: UIView!
    private let cookieTempView = CookieView.loadView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.presentGuideView()
    }
}

extension HomeViewController {
    private func setViews() {
        self.cookiesView.addSubview(self.cookieTempView)
        self.cookieTempView.fillSuperview()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(previewDragView(_:)))
        self.cookiesView.addGestureRecognizer(gesture)
    }
    
    private func presentGuideView() {
        let guideView = GuideViewController.createInstance(())
        self.present(guideView, animated: true)
    }
}

extension HomeViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier = "HomeViewController"
    public func bindData(value: ()) {
        
    }
}
