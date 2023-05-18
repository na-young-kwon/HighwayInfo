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
    var cardViewModel: CardViewModel?
    let apiProvider: DefaultAPIProvider
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator, apiProvider: DefaultAPIProvider) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.apiProvider = apiProvider
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
        let cardCoordinator = DefaultCardCoordinator(navigationController: navigationController, parentCoordinator: self)
        let cardUseCase = DefaultCardUseCase(roadRepository: DefaultRoadRepository(service: RoadService(apiProvider: apiProvider)))
        childCoordinators.append(cardCoordinator)
        cardViewModel = CardViewModel(coordinator: cardCoordinator, useCase: cardUseCase, highwayInfo: route.highwayInfo)
        controller.viewModel = ResultViewModel(coordinator: self, route: route, cardViewModel: cardViewModel!)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func removeCoordinator() {
        cardViewModel = nil
        parentCoordinator?.removeChildCoordinator(self)
    }
}
