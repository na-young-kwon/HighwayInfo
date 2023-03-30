//
//  RoadDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation

struct LocationInfo: Decodable {
    let count: Int
    let list: [RoadDTO]
}

struct RoadDTO: Decodable {
    let routeName: String
    let routeNumber: String
    let icCode: String
    let icName: String
    let coordx: String
    let coordy: String
    
    enum CodingKeys: String, CodingKey {
        case routeName, icCode, icName
        case routeNumber = "routeNo"
        case coordx = "xValue"
        case coordy = "yValue"
    }
}
