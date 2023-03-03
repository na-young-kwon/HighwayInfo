//
//  AppCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages = TabBarPage.allCases
        let controllers = pages.map({ makeTabNavigationController(of: $0) })
        configureTabBar(with: controllers)
        showTabBar()
    }
    
    private func showTabBar() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func configureTabBar(with vc: [UIViewController]) {
        tabBarController.setViewControllers(vc, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageNumber
        tabBarController.view.backgroundColor = .systemBackground
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.tabBar.tintColor = .white
    }
    
    private func makeTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let nav = UINavigationController()
        
        nav.setNavigationBarHidden(true, animated: true)
        nav.tabBarItem = UITabBarItem(title: page.stringValue, image: UIImage(named: "Box"), selectedImage: nil)
        startTabCoordinator(of: page, to: nav)
        return nav
    }
    
    private func startTabCoordinator(of page: TabBarPage, to navigationController: UINavigationController) {
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(navigationController)
            homeCoordinator.start()
        case .road:
            let roadCoordinator = DefaultRoadCoordinator(navigationController)
            roadCoordinator.start()
        }
    }
}
