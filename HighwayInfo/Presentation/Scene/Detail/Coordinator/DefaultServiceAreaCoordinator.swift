//
//  DefaultServiceAreaCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/04.
//

import UIKit

final class DefaultServiceAreaCoordinator: Coordinator {
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
    
    func start(with route: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(ofType: ServiceAreaViewController.self)
        controller.viewModel = ServiceAreaViewModel(coordinator: self)
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func removeCoordinator() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
