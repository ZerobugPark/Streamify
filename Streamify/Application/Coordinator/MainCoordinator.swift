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
        print(#function, navigationController)
    }
    
    func start() {
        showHome()
    }
    
    private func showHome() {
        let homeVC = MainViewController()
        print("homeVC instance:", Unmanaged.passUnretained(homeVC).toOpaque())
        print("homeVC.coordinator:", homeVC.coordinator as Any)
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: false)
    }
    
    func showSearchScreen() {
        let searchVC = SearchViewController()
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func showDetail(for item: MediaItem) {
        let coordinator = DetailCoordinator(navigationController: navigationController, mediaItem: item)
        coordinator.start()
    }
    
    func showStorageScreen() {
        let viewModel = StorageViewModel()
        let storageVC = StorageViewController(viewModel: viewModel)
        storageVC.coordinator = self
        navigationController.pushViewController(storageVC, animated: true)
    }
    
    func showStarRatingScreen(data: [Rate]) {
        let viewModel = StarRatingStorageViewModel()
        let starRatingVC = StarRatingStorageViewController(vm: viewModel, data: data)
        navigationController.pushViewController(starRatingVC, animated: true)
    }
    
    func showCommentScreen(data: [Comments]) {
        let viewModel = CommentViewModel()
        let commnetVC = CommentViewController(vm: viewModel, data: data)
        navigationController.pushViewController(commnetVC, animated: true)
    }
}
