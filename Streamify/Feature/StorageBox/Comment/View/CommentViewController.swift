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
    
    lazy var commetnsDatas = Observable.just(data)
    weak var coordinator: MainCoordinator?
    
    init(vm: CommentViewModel, data: [Comments]) {
        self.data = data
        super.init(viewModel: vm)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setupNavigation()
    }
    
    
    override func bindViewModel() {
        
        let input = CommentViewModel.Input(setInitialData: commetnsDatas)
        
        let output = viewModel.transform(input: input)
     
        output.setComments.asDriver(onErrorJustReturn: []).drive(mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.id, cellType: CommentTableViewCell.self)) { row, element, cell in
            
            cell.setupUI(element)
            
        }.disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Comments.self).bind(with: self) { owner, element in
            owner.coordinator?.showDetail(for: element.titleID)
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
        navigationItem.backButtonTitle = ""
    }
}
