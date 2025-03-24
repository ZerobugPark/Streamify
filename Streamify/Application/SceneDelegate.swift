//
//  SceneDelegate.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var onboardingCoordinator: OnboardingCoordinator?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController(rootViewController: DramaViewController(viewModel: DramaViewModel()))
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

//        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
//        print("isOnboardingCompleted", isOnboardingCompleted)
//
//        if isOnboardingCompleted {
//            // 온보딩 완료 → MainCoordinator를 통해 홈 화면 진입
//            mainCoordinator = MainCoordinator(navigationController: navigationController)
//            mainCoordinator?.start()
//        } else {
//            // 온보딩 미완료 → OnboardingCoordinator 시작
//            onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
//            onboardingCoordinator?.start()
//        }
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

