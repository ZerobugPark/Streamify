//
//  CommentViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import UIKit

import RxCocoa
import RxSwift

final class CommentViewController: BaseViewController <CommentView, CommentViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableView()
        view.backgroundColor = .setStreamifyColor(.baseBlack)
    }
    
    
    override func bindViewModel() {
        let a = Array(1...100)
        
        Observable.just(a).bind(to: mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.id, cellType: CommentTableViewCell.self)) { row, element, cell in
            
        }.disposed(by: disposeBag)
        
    }
   

}


extension CommentViewController {
    
    // MARK: - TableView Register
    private func registerTableView() {
        mainView.tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.id)
        
    }
    
    private func setupNavigation() {
        let title = "코멘트"
        navigationItem.title = title
    }
}
