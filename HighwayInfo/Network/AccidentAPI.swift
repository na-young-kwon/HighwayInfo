//
//  AccidentAPI.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/24.
//

import Foundation


struct AccidentRequest: APIRequest {
    typealias Response = [AccidentDTO]
    
    let httpMethod: HTTPMethod = .get
    let urlHost = "http://openapigits.gg.go.kr/api/rest/"
    let urlPath = "getIncidentInfo?"
    var parameters: [String : String] {[
        "serviceKey": Bundle.main.accidentApiKey
    ]}
}
