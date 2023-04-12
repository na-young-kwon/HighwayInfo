//
//  RouteRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/12.
//

import Foundation

struct RouteRequest: APIRequest {
    typealias Response = RouteDTO
        
    let httpMethod: HTTPMethod = .post
    let urlHost = "https://apis.openapi.sk.com/tmap/"
    let urlPath = "routes?"
    let version = "1"
    
    var parameters: [String : String] {[
        "version": version
    ]}
}
