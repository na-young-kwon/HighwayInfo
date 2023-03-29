//
//  DefaultRoadCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

final class DefaultRoadCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: RoadViewController.self)
        
        vc.viewModel = RoadViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toRoadDetail(with route: Route) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: DetailViewController.self)
        
        vc.viewModel = RoadDetailViewModel(route: route)
        navigationController.pushViewController(vc, animated: true)
    }
}