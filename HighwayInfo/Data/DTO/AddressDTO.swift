//
//  AddressDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/17.
//

import Foundation

struct AddressDTO: Decodable {
    let addressInfo: AddressInfo
}

struct AddressInfo: Decodable {
    let fullAddress, addressType, cityDo, guGun: String
    let eupMyun, adminDong, adminDongCode, legalDong: String
    let legalDongCode, ri, bunji, roadName: String
    let buildingIndex, buildingName, mappingDistance, roadCode: String
    
    enum CodingKeys: String, CodingKey {
        case fullAddress, addressType
        case cityDo = "city_do"
        case guGun = "gu_gun"
        case eupMyun = "eup_myun"
        case adminDong, adminDongCode, legalDong, legalDongCode, ri, bunji, roadName, buildingIndex, buildingName, mappingDistance, roadCode
    }
}
