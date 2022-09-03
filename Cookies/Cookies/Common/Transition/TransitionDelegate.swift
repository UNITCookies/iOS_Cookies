//
//  TransitionDelegate.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let present = AnimatorForPresent()
    let dismiss = AnimationForDismiss()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return present
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismiss
    }
}

class AnimatorForPresent: NSObject, UIViewControllerAnimatedTransitioning {
    var willPresent: (()->())?
    var didPresnet: (()->())?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let presentedView = presentedViewController.view else { return }
        presentedViewController.beginAppearanceTransition(true, animated: true)
        transitionContext.containerView.addSubview(presentedView)
        presentedView.layoutIfNeeded()
        self.willPresent?()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            self.didPresnet?()
            presentedView.layoutIfNeeded()
        }, completion: { finished in
            transitionContext.completeTransition(finished)
            presentedViewController.endAppearanceTransition()
        })
    }
}

class AnimationForDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    var willDismiss: (()->())?
    var didDismiss: (()->())?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissingViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let dismissingView = dismissingViewController.view else { return }
        dismissingViewController.beginAppearanceTransition(true, animated: true)
        self.willDismiss?()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            self.didDismiss?()
            dismissingView.layoutIfNeeded()
        }, completion: { finished in
            dismissingView.removeFromSuperview()
            transitionContext.completeTransition(finished)
            dismissingViewController.endAppearanceTransition()
        })
    }
}

