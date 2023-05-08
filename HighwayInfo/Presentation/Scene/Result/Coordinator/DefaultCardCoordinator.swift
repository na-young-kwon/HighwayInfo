//
//  DefaultCardCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import UIKit

final class DefaultCardCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
    }
    
    func showServiceDetail(with highwayName: String, serviceArea: [ServiceArea]) {
       let serviceCoordinator = DefaultServiceAreaCoordinator(
        navigationController: navigationController,
        parentCoordinator: self)
        childCoordinators.append(serviceCoordinator)
        serviceCoordinator.start()
        serviceCoordinator.start(with: highwayName, serviceArea: serviceArea)
    }
}
