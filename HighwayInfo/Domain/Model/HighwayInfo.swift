//
//  HighwayInfo.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/14.
//

import Foundation
import CoreLocation

struct HighwayInfo {
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: [Double]) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
    }
}
