//
//  Coordinator.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/03.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
