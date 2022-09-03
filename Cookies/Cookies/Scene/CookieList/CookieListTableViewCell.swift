//
//  CookieListTableViewCell.swift
//  Cookies
//
//  Created by Kim HeeJae on 2022/09/04.
//

import UIKit
import SnapKit

class CookieListTableViewCell : UITableViewCell {
    
    // MARK: - UI components
    
    let cookieImageView = UIImageView()
        
    let dateLabel = UILabel()
        
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func setupUI() {
        cookieImageView.image = UIImage(named: "cookie")
    }
    
    func makeConstraints() {
        contentView.addSubview(cookieImageView)
        
        cookieImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(contentView.snp.left).offset(15)
        }
    }
    
}
