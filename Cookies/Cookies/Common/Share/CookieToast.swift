//
//  CookieToast.swift
//  Cookies
//
//  Created by Kim HeeJae on 2022/09/03.
//

import Foundation
import UIKit
import SnapKit

class CookieToast : UIView {
    
    // MARK: - UI components
    
    private let messageLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupUI()
        makeConstraints()
    }
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setupUI() {
        self.backgroundColor = .lightGray
        self.alpha = 0.0
        self.isHidden = true
        
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 17)
        messageLabel.textColor = .black
        messageLabel.backgroundColor = .clear
    }
    
    private func makeConstraints() {
        addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self).inset(10)
            $0.verticalEdges.equalTo(self).inset(5)
        }
    }
    
    public func show(message: String) {
        messageLabel.text = message
        self.alpha = 0.0
        
        UIView.animate(withDuration: 2.0) {
            self.alpha = 1.0
            self.isHidden = false
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 2.0, delay: 3, options: .curveEaseOut, animations: { [self] in
             self.alpha = 0.0
            
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
            self.isHidden = true
        })
    }
    
}
