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
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.navigationBar.backIndicatorImage = UIImage(systemName: "circle")
        navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "circle")
        navigationController.navigationBar.backItem?.title = ""
    }
    
    func toResultView(with info: LocationInfo) {
        let resultCoordinator = DefaultResultCoordinator(navigationController)
        resultCoordinator.start(with: info)
    }
}
