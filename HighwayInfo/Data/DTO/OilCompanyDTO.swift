//
//  OilCompanyDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct OilCompanyDTO: Decodable {
    private let list: [OilCompany]
    private let count: Int
    private let pageNo: Int
    private let numOfRows: Int
    private let pageSize: Int
    private let message: String
    private let code: String
    
    var companyName: String? {
        guard let company = list.first else {
            return nil
        }
        return company.oilCompany
    }
}

struct OilCompany: Decodable {
    private let location: String
    private let pageNo: String?
    private let numOfRows: String?
    private let address: String
    private let routeName: String
    let oilCompany: String
    private let serviceAreaCode: String
    private let serviceAreaName: String
    private let routeCode: String
  
    
    enum CodingKeys: String, CodingKey {
        case address = "svarAddr"
        case location, pageNo, numOfRows, routeName, oilCompany
        case serviceAreaCode, serviceAreaName, routeCode
    }
}
