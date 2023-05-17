//
//  OilCompanyRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct OilCompanyRequest: APIRequest {
    typealias Response = OilCompanyDTO

    let httpMethod: HTTPMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/business/"
    let urlPath = "lpgServiceAreaInfo?"
    let key = Bundle.main.serviceAreaKey
    let type = "json"
    let serviceAreaName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "serviceAreaName": serviceAreaName,
    ]}
}
