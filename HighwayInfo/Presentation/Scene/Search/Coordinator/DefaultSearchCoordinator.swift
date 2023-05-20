//
//  SearchCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import UIKit
import CoreLocation

final class DefaultSearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let apiProvider: DefaultAPIProvider
    
    init(navigationController: UINavigationController, apiProvider: DefaultAPIProvider) {
        self.navigationController = navigationController
        self.apiProvider = apiProvider
    }
    
    func start() {
    }
    
    func toResultView(with route: Route) {
        let resultCoordinator = DefaultResultCoordinator(
            navigationController: navigationController,
            parentCoordinator: self, apiProvider: apiProvider
        )
        childCoordinators.append(resultCoordinator)
        resultCoordinator.start()
        resultCoordinator.start(with: route)
    }
}
