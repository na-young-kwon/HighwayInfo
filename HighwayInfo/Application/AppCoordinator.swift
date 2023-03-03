//
//  AppCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showTabbar()
    }
    
    func showTabbar() {
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home",
                                                           image: UIImage(named: "Box"),
                                                           selectedImage: nil)
        let homeCoordinator = DefaultHomeCoordinator(homeNavigationController)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        tabBarController.viewControllers = [homeNavigationController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        homeCoordinator.start()
    }
}
