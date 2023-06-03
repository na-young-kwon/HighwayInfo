//
//  GasStation.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

struct GasStation {
    let uuid: String
    let name: String
    let dieselPrice: String
    let gasolinePrice: String
    let lpgPrice: String
    let telNo: String
    let oilCompany: String?
    
    var oilCompanyImage: String? {
        switch oilCompany {
        case "SK":
            return "oilCompany_SK"
        case "현대":
            return "oilCompany_hyundai"
        case "GS-Caltex":
            return "oilCompany_GS-Caltex"
        case "알뜰":
            return "oilCompany_alddeul"
        case "S-Oil":
            return "oilCompany_S-Oil"
        default:
            return nil
        }
    }
}

extension GasStation: Hashable {
    static func == (lhs: GasStation, rhs: GasStation) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
