//
//  SearchCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/06/01.
//

import Foundation

protocol SearchCoordinator: Coordinator {
    func toResultView(with route: Route)
    func popViewController()
    func removeCoordinator()
}
