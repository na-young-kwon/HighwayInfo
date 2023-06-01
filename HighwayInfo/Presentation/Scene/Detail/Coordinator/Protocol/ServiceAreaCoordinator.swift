//
//  ServiceAreaCoordinator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/06/01.
//

import Foundation

protocol ServiceAreaCoordinator: Coordinator {
    func start(with highwayName: String, serviceArea: [ServiceArea])
    func toFacilityView(with serviceArea: ServiceArea)
    func removeCoordinator()
}
