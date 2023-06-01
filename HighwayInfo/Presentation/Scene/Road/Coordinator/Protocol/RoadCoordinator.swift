//
//  File.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/06/01.
//

import Foundation
import CoreLocation

protocol RoadCoordinator: Coordinator {
    func showSearchView(with currentLocation: CLLocationCoordinate2D)
}
