//
//  GasStationRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

struct GasStationRequest: APIRequest {
    typealias Response = [GasStationDTO]
        
    let httpMethod: HttpMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/restinfo/"
    let urlPath = "restOilList?"
    let key = Bundle.main.serviceAreaKey
    let type = "xml"
    let routeName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "routeNm": routeName
    ]}
}
