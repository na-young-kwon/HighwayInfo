//
//  DefaultCardCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import UIKit

final class DefaultCardCoordinator: CardCoordinator {
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
    
    func toFacilityView(with serviceArea: ServiceArea) {
        let facilityCoordinator = DefaultFacilityCoordinator(navigationController: navigationController, parentCoordinator: self)
        childCoordinators.append(facilityCoordinator)
        facilityCoordinator.start()
        facilityCoordinator.start(with: serviceArea)
    }
    
    func removeCoordinator() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
