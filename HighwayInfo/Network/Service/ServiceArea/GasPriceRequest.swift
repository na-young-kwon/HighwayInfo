//
//  GasPriceRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

struct GasPriceRequest: APIRequest {
    typealias Response = GasPriceDTO

    let httpMethod: HttpMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/business/"
    let urlPath = "curStateStation?"
    let key = Bundle.main.serviceAreaKey
    let type = "json"
    let serviceAreaName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "serviceAreaName": serviceAreaName
    ]}
}
