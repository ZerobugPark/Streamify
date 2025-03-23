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

    var data: [Comments]
    
    lazy var testData = BehaviorRelay(value: data)
    
    init(vm: CommentViewModel, data: [Comments]) {
        self.data = data
        print("Custom parameter: \(data)")
        
        // BaseViewController의 생성자 호출
        super.init(viewModel: vm)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableView()
        view.backgroundColor = .setStreamifyColor(.baseBlack)
    }
    
    
    override func bindViewModel() {
        
        
        testData.asDriver(onErrorJustReturn: []).drive(mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.id, cellType: CommentTableViewCell.self)) { row, element, cell in
        
            cell.setupUI(element)
            
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
