//
//  DefaultRoadCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit
import CoreLocation

final class DefaultRoadCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let apiProvider: DefaultAPIProvider
    
    init(_ navigationController: UINavigationController, apiProvider: DefaultAPIProvider) {
        self.navigationController = navigationController
        self.apiProvider = apiProvider
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: RoadViewController.self)  
        let roadUseCase = DefaultRoadUseCase(locationService: LocationService.shared)
        vc.viewModel = RoadViewModel(coordinator: self, useCase: roadUseCase)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSearchView(with currentLocation: CLLocationCoordinate2D) {
        let searchCoordinator = DefaultSearchCoordinator(navigationController: navigationController, apiProvider: apiProvider)
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
        searchCoordinator.start(with: currentLocation)
    }
}
