//
//  DefaultCardCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import UIKit

final class DefaultCardCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
       
    }
    
    func showServiceDetail(with routeName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: ServiceAreaViewController.self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showGasStationDetail(with routeName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: GasStationViewController.self)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
