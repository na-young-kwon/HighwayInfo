//
//  ConvenienceListRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/10.
//

import Foundation

struct ConvenienceListRequest: APIRequest {
    typealias Response = ConvenienceListDTO
    
    let httpMethod: HTTPMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/restinfo"
    let urlPath = "restConvList?"
    let key = "6970526905"
    let type = "json"
    let serviceAreaName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "stdRestNm": serviceAreaName,
    ]}
}
