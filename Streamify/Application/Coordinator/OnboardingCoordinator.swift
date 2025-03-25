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
    
    deinit { print("OnboardingCoordinator deinit")}
    
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
        print(UserDefaults.standard.object(forKey: "userName"))
        print(UserDefaults.standard.object(forKey: "preferredGenres"))
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        let navigationController = UINavigationController()
        sceneDelegate.window = window
        sceneDelegate.window?.rootViewController = navigationController

        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        sceneDelegate.mainCoordinator = mainCoordinator
        mainCoordinator.start()

        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        window.layer.add(transition, forKey: kCATransition)

        window.makeKeyAndVisible()
    }

}
