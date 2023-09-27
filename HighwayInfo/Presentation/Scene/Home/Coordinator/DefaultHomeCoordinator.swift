//
//  DefaultHomeCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

final class DefaultHomeCoordinator: HomeCoordinator {
    var navigationController: UINavigationController
    var homeViewController: HomeViewController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
    }
    
    func start() {
        let accidentRepository = DefaultAccidentRepository(service: AccidentService.live)
        let cctvRepository = DefaultCCTVRepository(service: CCTVService.live)
        homeViewController.viewModel = HomeViewModel(
            useCase: DefaultAccidentUseCase(accidentRepository: accidentRepository, cctvRepository: cctvRepository),
            coordinator: self
        )
        
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
