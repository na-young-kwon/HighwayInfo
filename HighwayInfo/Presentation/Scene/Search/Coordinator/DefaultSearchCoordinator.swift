//
//  SearchCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import UIKit
import CoreLocation

final class DefaultSearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let apiProvider: DefaultAPIProvider
    
    init(navigationController: UINavigationController, apiProvider: DefaultAPIProvider) {
        self.navigationController = navigationController
        self.apiProvider = apiProvider
    }

    func start() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func start(with currentLocation: CLLocationCoordinate2D) {
        let controller = SearchViewController()
        let searchUseCase = DefaultSearchUseCase(
            roadRepository: DefaultRoadRepository(
                service: RoadService(apiProvider: apiProvider)),
            userRepository: DefaultUserRepository(),
            locationService: LocationService.shared
        )
        controller.viewModel = SearchViewModel(useCase: searchUseCase, coordinator: self, currentLocation: currentLocation)
        navigationController.pushViewController(controller, animated: false)
    }
    
    func toResultView(with route: Route) {
        let resultCoordinator = DefaultResultCoordinator(
            navigationController: navigationController,
            parentCoordinator: self, apiProvider: apiProvider
        )
        childCoordinators.append(resultCoordinator)
        resultCoordinator.start()
        resultCoordinator.start(with: route)
    }
}
