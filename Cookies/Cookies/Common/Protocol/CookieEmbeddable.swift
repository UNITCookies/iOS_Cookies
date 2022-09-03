//
//  CookieEmbeddable.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

protocol CookieEmbeddable where Self: UIViewController{
    func show(_ viewController: UIViewController)
}

extension CookieEmbeddable {
    func show(_ viewController: UIViewController) {
        guard let to = viewController.view else { return }
        let first = self.children.first
        
        addChild(viewController)
        to.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        view.addSubview(to)
        viewController.didMove(toParent: self)
        
        to.setNeedsLayout()
        to.layoutIfNeeded()
        
        guard let from = first else { return }
        to.layer.shadowOpacity = 0.1
        to.layer.shadowOffset = CGSize(width: -5, height: 0)
        
        to.transform = CGAffineTransform.init(translationX: to.bounds.width, y: 0)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                to.transform = CGAffineTransform.identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
                from.view.transform = CGAffineTransform.init(translationX: -from.view.bounds.width/4, y: 0)
            })
            
        }, completion: { _ in
            from.willMove(toParent: nil)
            from.view.removeFromSuperview()
            from.removeFromParent()
            
            to.layer.shadowColor = UIColor.clear.cgColor
            to.layer.shadowOpacity = 0.0
            to.layer.shadowOffset = CGSize(width: 0, height: 0)
        })
    }
}
