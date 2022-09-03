//
//  GuideViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

class GuideViewController: UIViewController {
    private let transitioning = TransitioningDelegate()
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.transitioningDelegate  = self.transitioning
        self.modalPresentationStyle = .overCurrentContext
    }
}
