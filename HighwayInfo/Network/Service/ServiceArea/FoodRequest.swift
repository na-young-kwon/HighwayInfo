//
//  File.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct FoodRequest: APIRequest {
    typealias Response = FoodDTO

    let httpMethod: HTTPMethod = .get
    let urlHost = "http://data.ex.co.kr/openapi/restinfo/"
    let urlPath = "restBestfoodList?"
    let key = "6970526905"
    let type = "json"
    let numOfRows = "10"
    let stdRestNm: String
    
    var parameters: [String : String] {[
        "key": key,
        "type": type,
        "numOfRows": numOfRows,
        "stdRestNm": stdRestNm
    ]}
}
