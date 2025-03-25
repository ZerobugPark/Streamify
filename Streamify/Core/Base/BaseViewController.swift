//
//  BaseViewController.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import UIKit
import RxSwift

class BaseViewController<T: UIView, VM: BaseViewModel>: UIViewController, ViewControllerType {
    
    var disposeBag = DisposeBag()
    let mainView = T()
    let viewModel: VM
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit { print("\(Self.description()) is deinit") }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
        
    }

    func setupUI() { }
    func bindViewModel() { }
    
    
}

