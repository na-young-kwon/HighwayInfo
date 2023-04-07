//
//  LocationInfo.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import Foundation

struct LocationInfo: Hashable {
    let id = UUID()
    let name: String
    let address: String?
    let businessName: String
    let distance: String
}
