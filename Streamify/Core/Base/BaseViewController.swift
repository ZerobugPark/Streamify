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
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(showNetworkErrorAlert),
//            name: NSNotification.Name("ReloadLikedButtons"),
//            object: nil
//        )
    }

    func setupUI() { }
    func bindViewModel() { }
    
    
//    @objc
//    func showNetworkErrorAlert() {
//        DispatchQueue.main.async {
//            AlertManager.shared.showAlert(
//                on: self,
//                title: "안내",
//                message: "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요.",
//                actions: [
//                    UIAlertAction(title: "다시 시도하기", style: .destructive, handler: { [weak self] _ in
//                        if NetworkMonitorManager.shared.isConnected {
//                            self?.viewModel.retryTrigger.accept(())
//                        } else {
//                            self?.view.makeToast("네트워크 통신이 원활하지 않습니다.") // TODO: 리터럴값 로컬라이징
//                        }
//                    })
//                ]
//            )
//        }
//    }
    
}

