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
    private let apiProvider: DefaultAPIProvider
    
    init(_ navigationController: UINavigationController, apiProvider: DefaultAPIProvider) {
        self.navigationController = navigationController
        self.apiProvider = apiProvider
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: HomeViewController.self)
        let accidentRepository = DefaultAccidentRepository(service: AccidentService(apiProvider: apiProvider))
        let cctvRepository = DefaultCCTVRepository(service: CCTVService(apiProvider: apiProvider))
        
        vc.viewModel = HomeViewModel(
            useCase: DefaultAccidentUseCase(
                accidentRepository: accidentRepository,
                cctvRepository: cctvRepository),
            coordinator: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
