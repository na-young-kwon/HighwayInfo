//
//  OilCompanyDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct OilCompanyDTO: Decodable {
    let list: [OilCompony]
    let count: Int
    let pageNo: Int
    let numOfRows: Int
    let pageSize: Int
    let message: String
    let code: String
}

struct OilCompony: Decodable {
    let location: String
    let pageNo: String?
    let numOfRows: String?
    let address: String
    let routeName: String
    let oilCompany: String
    let serviceAreaCode: String
    let serviceAreaName: String
    let routeCode: String
  
    
    enum CodingKeys: String, CodingKey {
        case address = "svarAddr"
        case location, pageNo, numOfRows, routeName, oilCompany
        case serviceAreaCode, serviceAreaName, routeCode
    }
}
