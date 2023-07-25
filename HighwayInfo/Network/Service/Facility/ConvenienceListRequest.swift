//
//  ConvenienceListRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/10.
//

import Foundation

struct ConvenienceListRequest: APIRequest {
    typealias Response = ConvenienceListDTO
    
    let httpMethod: HttpMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/restinfo/"
    let urlPath = "restConvList?"
    let key = Bundle.main.serviceAreaKey
    let type = "json"
    let serviceAreaName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "stdRestNm": serviceAreaName,
    ]}
}
