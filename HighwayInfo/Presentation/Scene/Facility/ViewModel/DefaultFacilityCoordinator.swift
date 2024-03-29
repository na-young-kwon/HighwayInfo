//
//  DefaultFacilityCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/08.
//

import UIKit

final class DefaultFacilityCoordinator: FacilityCoordinator {
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
    
    func start(with serviceArea: ServiceArea) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(ofType: FacilityViewController.self)
        let facilityService = FacilityService.live
        let roadRepository = DefaultRoadRepository(service: RoadService.live)
        let facilityRepository = DefaultFacilityRepository(service: facilityService)
        controller.viewModel = FacilityViewModel(coordinator: self, useCase: DefaultFacilityUseCase(roadRepository: roadRepository, facilityRepository: facilityRepository), serviceArea: serviceArea)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func removeCoordinator() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
