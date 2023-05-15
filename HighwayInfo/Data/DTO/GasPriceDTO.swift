//
//  GasPriceDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

struct GasPriceDTO: Decodable {
    private let list: [GasPrice]
    private let count: Int
    private let pageNo: Int
    private let numOfRows: Int
    private let pageSize: Int
    private let message: String
    private let code: String
    
    var toDomain: GasStation? {
        if list.isEmpty {
            return nil
        }
        return list.map { GasStation(name: $0.name,
                                     dieselPrice: $0.diselPrice,
                                     gasolinePrice: $0.gasolinePrice,
                                     lpgPrice: $0.lpgPrice,
                                     oilCompany: nil) }.first
    }
    var gasStation: GasPrice? {
        guard let gasStation = list.first else {
            return nil
        }
        return gasStation
    }
}

struct GasPrice: Decodable {
    private let direction: String
    private let pageNo: String?
    private let numOfRows: String?
    private let address: String
    private let routeName: String
    private let oilCompany: String
    let name: String
    let diselPrice: String
    let gasolinePrice: String
    let lpgPrice: String
    private let telNo: String
    private let serviceAreaCode: String
    private let routeCode: String
    private let lpgYn: String
    private let serviceAreaCode2: String
    
    enum CodingKeys: String, CodingKey {
        case address = "svarAddr"
        case name = "serviceAreaName"
        case direction, pageNo, numOfRows, routeName, oilCompany, diselPrice
        case gasolinePrice, lpgPrice, telNo, serviceAreaCode, routeCode, lpgYn, serviceAreaCode2
    }
}
