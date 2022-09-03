//
//  HomeViewController+Gesture.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

extension HomeViewController {
    @objc
    func previewDragView(_ gesture : UIGestureRecognizer){
        let point  = gesture.location(in: self.view)
        let height = self.view.frame.height
        let cookiesView = gesture.view
        
        var contentViewHeight: CGFloat = UIApplication.safeAreaInsets.bottom
        contentViewHeight += cookiesView?.frame.height ?? 0.0
        
        if gesture.state == .changed {
            if point.y >= 0 && point.y <= height{
                let differ = (height - contentViewHeight) - point.y
                self.infoViewBottomConst.constant = differ + contentViewHeight
            }
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [],
                           animations: {
                            if point.y <= self.view.frame.height / 2 {
//                                self.previewFullSignal.accept(())
                            } else if self.view.frame.height - point.y <= (contentViewHeight * 2) / 3 {
//                                self.dismissPreview()
                            } else {
//                                height = contentViewHeight
//                                preview.snp.updateConstraints({ make in
//                                    make.height.equalTo(height)
//                                })
                            }
                            
                self.view.layoutIfNeeded()
            })
        }
    }
}
