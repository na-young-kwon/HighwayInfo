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
        let useCase = DefaultRoadUseCase(roadRepository: DefaultRoadRepository(service: RoadService(apiProvider: apiProvider)), locationService: LocationService.shared)
        searchViewModel = SearchViewModel(useCase: useCase, coordinator: DefaultSearchCoordinator(navigationController))
        vc.viewModel = RoadViewModel(coordinator: self, useCase: useCase)
        navigationController.pushViewController(vc, animated: true)
    }
}
