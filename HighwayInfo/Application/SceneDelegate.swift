//
//  SceneDelegate.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
//        let navigationController = UINavigationController()
        self.window = UIWindow(windowScene: windowScene)

        guard let window = window else {
            return
        }
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
//        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
    }
}
