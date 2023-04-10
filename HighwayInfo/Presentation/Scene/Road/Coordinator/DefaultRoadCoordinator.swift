//
//  DefaultRoadCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

final class DefaultRoadCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var searchViewModel: SearchViewModel?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: RoadViewController.self)
        let apiProvider = DefaultAPIProvider()
        
        let roadUseCase = DefaultRoadUseCase(locationService: LocationService.shared)
        let searchUseCase = DefaultSearchUseCase(roadRepository: DefaultRoadRepository(service: RoadService(apiProvider: apiProvider)))
        let searchCoordinator = DefaultSearchCoordinator(navigationController)
        searchCoordinator.start()
        
        searchViewModel = SearchViewModel(useCase: searchUseCase, coordinator: searchCoordinator)
        vc.viewModel = RoadViewModel(coordinator: self, useCase: roadUseCase)
        navigationController.pushViewController(vc, animated: true)
    }
}
