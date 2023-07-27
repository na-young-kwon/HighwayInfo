//
//  File.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct FoodRequest: APIRequest {
    typealias Response = FoodDTO

    let httpMethod: HttpMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/restinfo/"
    let urlPath = "restBestfoodList?"
    let key = Bundle.main.serviceAreaKey
    let type = "json"
    let numOfRows = "10"
    let serviceName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "numOfRows": numOfRows,
        "stdRestNm": serviceName
    ]}
}
