//
//  GasStation.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

struct GasStation {
    let name: String
    let address: String
    let dieselPrice: String
    let gasolinePrice: String
    let lpgPrice: String
    let serviceAreaCode: String
    let evCharging: Bool
    let hydrogenCharging: Bool
}

extension GasStation: Hashable {
    static func == (lhs: GasStation, rhs: GasStation) -> Bool {
        lhs.serviceAreaCode == rhs.serviceAreaCode
    }
}
