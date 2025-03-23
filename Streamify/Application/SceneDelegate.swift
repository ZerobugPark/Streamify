//
//  SceneDelegate.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: OnboardingCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
        print("isOnboardingCompleted", UserDefaults.standard.bool(forKey: "isOnboardingCompleted"))

        if isOnboardingCompleted {
            // 온보딩 완료 → 메인 화면 바로 진입
            let mainVC = MainViewController() // TODO: 실제 MainCoordinator 연동 시 변경
            navigationController.setViewControllers([mainVC], animated: false)
        } else {
            // 온보딩 미완료 → OnboardingCoordinator로 온보딩 플로우 시작
            coordinator = OnboardingCoordinator(navigationController: navigationController)
            coordinator?.start()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

