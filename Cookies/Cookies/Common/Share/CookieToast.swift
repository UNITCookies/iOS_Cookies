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
    
    private let titleLabel = UILabel()
    private let explainLabel = UILabel()
    
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
        self.backgroundColor = .main
        self.layer.cornerRadius = 20
        self.alpha = 0.0
        self.isHidden = true
        
        titleLabel.textAlignment = .center
        titleLabel.font = .pop1
        titleLabel.textColor = .sub
        titleLabel.backgroundColor = .clear
        
        explainLabel.textAlignment = .center
        explainLabel.font = .pop2
        explainLabel.textColor = .sub
        explainLabel.backgroundColor = .clear
    }
    
    private func makeConstraints() {
        addSubview(titleLabel)
        addSubview(explainLabel)
        
        self.snp.makeConstraints {
            $0.width.equalTo(249)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(16)
            $0.horizontalEdges.equalTo(self)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.bottom.equalTo(self.snp.bottom).inset(16)
        }
    }
    
    public func show(title: String, explain: String) {
        titleLabel.text = title
        explainLabel.text = explain
        self.alpha = 0.0
        
        UIView.animate(withDuration: 2.0) {
            self.alpha = 1.0
            self.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hide()
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
