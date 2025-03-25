//
//  MainCoordinator.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var detailCoordinator: DetailCoordinator?
    
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
    
    func showDetail(for item: Int) {
        let coordinator = DetailCoordinator(navigationController: navigationController, id: item)
        self.detailCoordinator = coordinator
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
        starRatingVC.coordinator = self
        navigationController.pushViewController(starRatingVC, animated: true)
    }
    
    func showCommentScreen(data: [Comments]) {
        let viewModel = CommentViewModel()
        let commnetVC = CommentViewController(vm: viewModel, data: data)
        commnetVC.coordinator = self
        navigationController.pushViewController(commnetVC, animated: true)
    }
    
    func showModifyScreen() {
        let modifyVC = ModifyViewController()
        modifyVC.coordinator = self
        navigationController.pushViewController(modifyVC, animated: true)
    }
    
    func showModifyGenreScreen() {
        let viewModel = GenreSelectionViewModel()
        let modifyGenreVC = ModifyGenreViewController(viewModel: viewModel)
        modifyGenreVC.coordinator = self
        navigationController.pushViewController(modifyGenreVC, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
}
