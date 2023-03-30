//
//  RoadRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation

struct RoadRequest: APIRequest {
    typealias Response = LocationInfo
    
    let httpMethod: HTTPMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/locationinfo/"
    let urlPath = "locationinfoIc?"
    let routeNo: String
    
    var parameters: [String : String] {[
        "key": "6970526905",
        "type" : "json",
        "routeNo" : routeNo
    ]}
}
