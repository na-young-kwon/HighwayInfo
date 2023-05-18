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
    let apiProvider: DefaultAPIProvider
    
    init(_ navigationController: UINavigationController, apiProvider: DefaultAPIProvider) {
        self.navigationController = navigationController
        self.apiProvider = apiProvider
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: RoadViewController.self)
        let apiProvider = DefaultAPIProvider()
        
        let roadUseCase = DefaultRoadUseCase(locationService: LocationService.shared)
        let searchUseCase = DefaultSearchUseCase(roadRepository: DefaultRoadRepository(service: RoadService(apiProvider: apiProvider)), userRepository: DefaultUserRepository())
        let searchCoordinator = DefaultSearchCoordinator(navigationController: navigationController, apiProvider: apiProvider)
        searchCoordinator.start()
        
        searchViewModel = SearchViewModel(useCase: searchUseCase, coordinator: searchCoordinator)
        vc.viewModel = RoadViewModel(coordinator: self, useCase: roadUseCase)
        childCoordinators.append(searchCoordinator)
        navigationController.pushViewController(vc, animated: true)
    }
}
