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
    
    func start(with highwayName: String, serviceArea: [ServiceArea]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(ofType: ServiceAreaViewController.self)
        controller.viewModel = ServiceAreaViewModel(coordinator: self, useCase: DefaultServiceAreaUseCase(), highwayName: highwayName, serviceArea: serviceArea)
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toFacilityView(with serviceArea: ServiceArea) {
        let facilityCoordinator = DefaultFacilityCoordinator(navigationController: navigationController, parentCoordinator: self)
        childCoordinators.append(facilityCoordinator)
        facilityCoordinator.start()
        facilityCoordinator.start(with: serviceArea)
    }
    
    func removeCoordinator() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
