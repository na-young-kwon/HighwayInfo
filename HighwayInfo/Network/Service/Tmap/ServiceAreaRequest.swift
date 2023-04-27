//
//  ServiceAreaRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/27.
//

import Foundation

struct ServiceAreaRequest: APIRequest {
    typealias Response = ServiceAreaDTO

    let httpMethod: HTTPMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/business/"
    let urlPath = "serviceAreaRoute?"
    let key = "6970526905"
    let type = "xml"
    let numOfRows = "15"
    let routeName: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "numOfRows": numOfRows,
        "routeName": routeName
    ]}
}
