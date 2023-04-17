//
//  ResultCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit
import CoreLocation

final class DefaultResultCoordinator: Coordinator {
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
    
    func start(with route: Route) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(ofType: ResultViewController.self)
        let useCase = DefaultResultUseCase(roadRepository: DefaultRoadRepository(service: RoadService(apiProvider: DefaultAPIProvider())))
        controller.viewModel = ResultViewModel(coordinator: self,
                                               route: route,
                                               useCase: useCase
        )
        navigationController.pushViewController(controller, animated: true)
    }
    
    func removeCoordinator() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
