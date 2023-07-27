//
//  DefaultHomeCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

final class DefaultHomeCoordinator: HomeCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: HomeViewController.self)
        let accidentRepository = DefaultAccidentRepository(service: AccidentService.live)
        let cctvRepository = DefaultCCTVRepository(service: CCTVService.live)
        vc.viewModel = HomeViewModel(
            useCase: DefaultAccidentUseCase(
                accidentRepository: accidentRepository,
                cctvRepository: cctvRepository),
            coordinator: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
