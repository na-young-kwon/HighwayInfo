//
//  HighwayInfo.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/14.
//

import Foundation
import CoreLocation

struct HighwayInfo {
    let uuid = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: [Double]) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
    }
    
    var rawName: String {
        name.replacingOccurrences(of: "고속도로", with: "").replacingOccurrences(of: " ", with: "")
    }
}

extension HighwayInfo: Hashable {
    static func == (lhs: HighwayInfo, rhs: HighwayInfo) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(coordinate)
    }
}

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
