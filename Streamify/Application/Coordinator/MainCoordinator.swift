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
        navigationController.setViewControllers([homeVC], animated: true)
    }
}
