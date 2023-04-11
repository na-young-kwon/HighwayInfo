//
//  ResultCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit

final class DefaultResultCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func start(with info: LocationInfo) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(ofType: ResultViewController.self)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
