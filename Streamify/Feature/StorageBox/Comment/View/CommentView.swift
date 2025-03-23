//
//  CommentView.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import UIKit

final class CommentView: BaseView {

    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubviews(searchBar, tableView)
    }
    
    override func configureLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(self)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(self)
        }
        
    }
    
    override func configureView() {
        
        searchBar.showsCancelButton = true
        searchBar.searchTextField.leftView?.tintColor = .setStreamifyColor(.baseWhite) // 돋보기 색상 변경
        searchBar.searchTextField.textColor = .setStreamifyColor(.baseWhite)
        searchBar.tintColor = .setStreamifyColor(.baseWhite)
        searchBar.searchBarStyle = .minimal
        
        
        tableView.backgroundColor = .setStreamifyColor(.baseBlack)
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 100
        
    }
    
    
}
