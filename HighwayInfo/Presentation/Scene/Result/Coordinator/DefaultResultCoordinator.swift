//
//  ResultCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit
import CoreLocation

final class DefaultResultCoordinator: ResultCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var cardViewModel: CardViewModel?
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
        let cardCoordinator = DefaultCardCoordinator(navigationController: navigationController, parentCoordinator: self)
        let cardUseCase = DefaultCardUseCase(roadRepository: DefaultRoadRepository(service: RoadService.live))
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
