//
//  CookieListViewController.swift
//  Cookies
//
//  Created by Kim HeeJae on 2022/09/04.
//

import UIKit
import SnapKit

class CookieListViewController: CKBaseViewController {
    
    // MARK: - UI components
    
    private let cookieListTableView = UITableView()
         
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Functions
    
    func setupUI() {
        cookieListTableView.separatorStyle = .singleLine
        
        cookieListTableView.delegate = self
        cookieListTableView.dataSource = self
        cookieListTableView.register(CookieListTableViewCell.self, forCellReuseIdentifier: "CookieListTableViewCell")
    }
    
    func makeConstraints() {
        view.addSubview(cookieListTableView)
        
        cookieListTableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
}

// MARK: - CookieList TableView Delegate

extension CookieListViewController : UITableViewDelegate { }

// MARK: - CookieList TableView DataSource

extension CookieListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CookieListTableViewCell", for: indexPath) as? CookieListTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hi there", indexPath.row)
    }

}
