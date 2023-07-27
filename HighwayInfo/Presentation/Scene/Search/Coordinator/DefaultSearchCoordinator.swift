//
//  SearchCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import UIKit
import CoreLocation

final class DefaultSearchCoordinator: SearchCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

    func start() {
    }
    
    func start(with currentLocation: CLLocationCoordinate2D) {
        let controller = SearchViewController()
        let searchUseCase = DefaultSearchUseCase(
            roadRepository: DefaultRoadRepository(
                service: RoadService.live),
            userRepository: DefaultUserRepository(),
            locationService: DefaultLocationService.shared
        )
        controller.viewModel = SearchViewModel(useCase: searchUseCase, coordinator: self, currentLocation: currentLocation)
        navigationController.pushViewController(controller, animated: false)
    }
    
    func toResultView(with route: Route) {
        let resultCoordinator = DefaultResultCoordinator(
            navigationController: navigationController,
            parentCoordinator: self)
        childCoordinators.append(resultCoordinator)
        resultCoordinator.start()
        resultCoordinator.start(with: route)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: false)
    }
    
    func removeCoordinator() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
