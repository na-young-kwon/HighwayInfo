//
//  CCTVRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation

struct CCTVRequest: APIRequest {
    typealias Response = CctvDTO?
    
    let httpMethod: HttpMethod = .get
    let urlHost = "https://openapi.its.go.kr:9443/"
    let urlPath = "cctvInfo?"
    let apiKey = Bundle.main.cctvApiKey
    let type = "ex"
    let cctvType: CCTVType
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double
    let getType = "xml"
    
    var parameters: [String : String] {[
        "apiKey": apiKey,
        "type": type,
        "cctvType": cctvType.rawValue,
        "minX": String(minX),
        "maxX": String(maxX),
        "minY": String(minY),
        "maxY": String(maxY),
        "getType": getType
    ]}
}
