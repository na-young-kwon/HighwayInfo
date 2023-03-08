//
//  AccidentRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation

struct AccidentRequest: APIRequest {
    typealias Response = AccidentDTO
    
    let httpMethod: HTTPMethod = .get
    let urlHost: String = "http://openapigits.gg.go.kr/api/rest/"
    let urlPath: String = "getIncidentInfo?"
    let parameters: [String : String] = ["serviceKey": "952f3149f2bac24e515f8fb0b84bcc14ba2edc"]
}
