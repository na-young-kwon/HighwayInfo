//
//  ServiceAreaDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/27.
//

import Foundation

class ServiceAreaDTO: Decodable {
    var serviceAreaName: String!
    var serviceAreaCode: String!
    var convenience: String!
    var direction: String!
    var address: String!
    var telNo: String!
    var gasStationCode: String!
}
