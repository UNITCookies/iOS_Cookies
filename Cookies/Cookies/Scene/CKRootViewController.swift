//
//  CKRootViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

class CKRootViewController: UIViewController, CookieEmbeddable, RootContainerable {
    
    @IBOutlet weak var tabBar: UIView!
    var coordinator: RootCoordinator?
    let naviViewController: UINavigationController? = {
        let nav = UINavigationController()
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navi = self.naviViewController {
            self.show(navi)
        }
        self.coordinator = RootCoordinator(root: self)
        self.coordinator?.start()
        self.view.bringSubviewToFront(self.tabBar)
    }
}

extension CKRootViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier         = "CKRootViewController"
    public func bindData(value: ()) {
        
    }
}
