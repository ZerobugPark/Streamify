//
//  OnboardingCoordinator.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showNameInputScreen()
    }

    private func showNameInputScreen() {
        let nameInputVC = NameInputViewController()
        nameInputVC.coordinator = self
        navigationController.pushViewController(nameInputVC, animated: true)
    }

    func showGenreSelectionScreen(userName: String) {
        let genreSelectionVC = GenreSelectionViewController()
        genreSelectionVC.coordinator = self
        genreSelectionVC.userName = userName
        navigationController.pushViewController(genreSelectionVC, animated: true)
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
        let mainVC = ViewController() // TODO: MainView로 변경 필요
        navigationController.setViewControllers([mainVC], animated: true)
    }
}
