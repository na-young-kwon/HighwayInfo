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
        let controllers = pages.map { makeTabNavigationController(of: $0) }
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
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.tabBar.tintColor = .black
        configureTabBarShadow(tabBar: tabBarController.tabBar)
    }
    
    private func makeTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(title: page.stringValue,
                                      image: UIImage(named: page.imageName),
                                      selectedImage: UIImage(named: page.imageName)?.withRenderingMode(.alwaysOriginal))
        startTabCoordinator(of: page, to: nav)
        return nav
    }
    
    private func startTabCoordinator(of page: TabBarPage, to navigationController: UINavigationController) {
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(navigationController)
            homeCoordinator.start()
        case .search:
            let roadCoordinator = DefaultRoadCoordinator(navigationController)
            roadCoordinator.start()
        }
    }
}


extension AppCoordinator {
    private func configureTabBarShadow(tabBar: UITabBar) {
        let appearance = UITabBarAppearance()
        // set tabbar opacity
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        // shadow
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.15
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 6
    }
}
