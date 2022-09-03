//
//  CheckCookieView.swift
//  Cookies
//
//  Created by Kim HeeJae on 2022/09/03.
//

import UIKit

final class CheckCookieView: UIView {
    
    // MARK: - UI components
    
    private let cookieImageView = UIImageView()
    private let titleLaebl = UILabel()
    private let explainLaebl = UILabel()
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func setupUI() {
        cookieImageView.image = UIImage(named: "cookie")
        
        titleLaebl.text = "쿠키를 확인할까요?"
        titleLaebl.font = .title2
        titleLaebl.textColor = .black
        
        explainLaebl.text = "코인 1개를 사용하여 메세지를 읽습니다"
        explainLaebl.font = .text2
        explainLaebl.textColor = .gray
    }
    
    func makeConstraints() {
        addSubview(cookieImageView)
        addSubview(titleLaebl)
        addSubview(explainLaebl)
        
        cookieImageView.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).offset(40-20)
        }
        titleLaebl.snp.makeConstraints {
            $0.centerX.equalTo(cookieImageView)
            $0.top.equalTo(cookieImageView.snp.bottom).offset(20)
        }
        explainLaebl.snp.makeConstraints {
            $0.centerX.equalTo(titleLaebl)
            $0.top.equalTo(titleLaebl.snp.bottom).offset(6)
            $0.bottom.equalTo(self).inset(30)
        }
    }
    
    func setEnableCount(count: Int) {
        switch count {
        case 4:
            cookieImageView.image = UIImage(named: "cookie")
        case 3:
            cookieImageView.image = UIImage(named: "cookie_quater")
        case 2:
            cookieImageView.image = UIImage(named: "cookie_half")
        case 1:
            cookieImageView.image = UIImage(named: "cookie_last")
        default:
            break
        }
    }
}
