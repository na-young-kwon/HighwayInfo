//
//  GasPriceRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

struct GasPriceRequest: APIRequest {
    typealias Response = [GasPriceDTO]

    let httpMethod: HTTPMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/business/"
    let urlPath = "curStateStation?"
    let key = "6970526905"
    let type = "xml"
    let serviceAreaCode2: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "serviceAreaCode2": serviceAreaCode2
    ]}
}
