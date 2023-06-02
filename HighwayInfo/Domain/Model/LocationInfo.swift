//
//  LocationInfo.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import Foundation

struct LocationInfo: Hashable, Codable {
    let id: String
    let name: String
    let businessName: String
    let distance: String
    let coordx: String
    let coordy: String
    let address: String?
    
    init(uuid: String,
         name: String,
         businessName: String,
         distance: String,
         coordx: String,
         coordy: String,
         address: String?
    ) {
        self.id = uuid
        self.name = name
        self.businessName = businessName
        self.coordx = coordx
        self.coordy = coordy
        self.address = address
        self.distance = String(format: "%.1f", Double(distance) ?? 0)
    }
}
