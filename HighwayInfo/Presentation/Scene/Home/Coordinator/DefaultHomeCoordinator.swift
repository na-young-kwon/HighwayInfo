//
//  DefaultHomeCoordinator.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/03.
//

import UIKit

final class DefaultHomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: HomeViewController.self)
        vc.viewModel = HomeViewModel(
            useCase: DefaultAccidentUseCase(
                repository: DefaultAccidentRepository(
                    service: RoadService(
                        apiProvider: DefaultAPIProvider())
                )
            ),
            coordinator: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
