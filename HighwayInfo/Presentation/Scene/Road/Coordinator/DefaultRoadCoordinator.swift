//
//  DefaultRoadCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit
import CoreLocation

final class DefaultRoadCoordinator: RoadCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: RoadViewController.self)  
        let roadUseCase = DefaultRoadUseCase(locationService: DefaultLocationService.shared)
        vc.viewModel = RoadViewModel(useCase: roadUseCase, coordinator: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSearchView(with currentLocation: CLLocationCoordinate2D) {
        let searchCoordinator = DefaultSearchCoordinator(navigationController: navigationController, parentCoordinator: self)
        
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
        searchCoordinator.start(with: currentLocation)
    }
}
