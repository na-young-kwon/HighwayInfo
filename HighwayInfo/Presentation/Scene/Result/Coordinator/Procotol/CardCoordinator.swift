//
//  CardCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/06/01.
//

import Foundation

protocol CardCoordinator: Coordinator {
    func showServiceDetail(with highwayName: String, serviceArea: [ServiceArea])
    func toFacilityView(with serviceArea: ServiceArea)
    func removeCoordinator()
    func popViewController()
}
