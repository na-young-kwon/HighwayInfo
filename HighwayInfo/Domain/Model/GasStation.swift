//
//  GasStation.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

struct GasStation {
    let uuid = UUID()
    let name: String
    let dieselPrice: String
    let gasolinePrice: String
    let lpgPrice: String
    let oilCompany: String?
}

extension GasStation: Hashable {
    static func == (lhs: GasStation, rhs: GasStation) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
