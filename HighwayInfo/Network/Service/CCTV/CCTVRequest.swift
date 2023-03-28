//
//  CCTVRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation

struct CCTVRequest: APIRequest {
    typealias Response = CctvDTO?
    
    let httpMethod: HTTPMethod = .get
    let urlHost: String = "https://openapi.its.go.kr:9443/"
    let urlPath: String = "cctvInfo?"
    let type: String = "ex"
    let cctvType: CCTVType
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double
    let getType = "xml"
    
    var parameters: [String : String] {[
        "apiKey": "5178d00cd45340f58aedda032872a0e0",
        "type": type,
        "cctvType": cctvType.rawValue,
        "minX": String(minX),
        "maxX": String(maxX),
        "minY": String(minY),
        "maxY": String(maxY),
        "getType": getType
    ]}
}
