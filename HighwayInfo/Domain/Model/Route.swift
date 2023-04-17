//
//  Route.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/17.
//

import Foundation
import CoreLocation

struct Route {
    let startPointName: String
    let endPointName: String
    let path: [CLLocationCoordinate2D]
    let markerPoint: (CLLocationCoordinate2D, CLLocationCoordinate2D)
    let highwayInfo: [HighwayInfo]
}
