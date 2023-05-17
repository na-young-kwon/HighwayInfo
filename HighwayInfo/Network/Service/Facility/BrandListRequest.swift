//
//  BrandListRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct BrandListRequest: APIRequest {
    typealias Response = BrandListDTO
    
    let httpMethod: HTTPMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/restinfo/"
    let urlPath = "restBrandList?"
    let key = Bundle.main.serviceAreaKey
    let type = "json"
    let serviceAreaName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "stdRestNm": serviceAreaName,
    ]}
}
