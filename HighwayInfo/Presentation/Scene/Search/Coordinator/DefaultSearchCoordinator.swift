//
//  SearchCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import UIKit

final class DefaultSearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    }
    
    func toResultView(with info: LocationInfo) {
        let resultCoordinator = DefaultResultCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        childCoordinators.append(resultCoordinator)
        resultCoordinator.start()
        resultCoordinator.start(with: info)
    }
}
