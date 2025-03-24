//
//  MainCoordinator.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showHome()
    }

    private func showHome() {
        let homeVC = MainViewController()
        // TODO: 나중에 ViewModel 주입, 탭바 연동 등이 들``어갈 수 있음
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: true)
    }
    
    func showStorageScreen() {
        let viewModel = StorageViewModel()
        let storageVC = StorageViewController(viewModel: viewModel)
        storageVC.coordinator = self
        navigationController.pushViewController(storageVC, animated: true)
    }
    
    func starRatingScreen(data: [Rate]) {
        let viewModel = StarRatingStorageViewModel()
        let starRatingVC = StarRatingStorageViewController(vm: viewModel, data: data)
        navigationController.pushViewController(starRatingVC, animated: true)
    }
}
