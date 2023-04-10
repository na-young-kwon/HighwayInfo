//
//  SearchRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/06.
//

import Foundation

struct SearchRequest: APIRequest {
    typealias Response = SearchResultDTO
        
    let httpMethod: HTTPMethod = .get
    let urlHost = "https://apis.openapi.sk.com/tmap/"
    let urlPath = "pois?"
    let version = "2.12"
    let searchKeyword: String
    let longitude: Double
    let latitude: Double
    
    var parameters: [String : String] {[
        "version": version,
        "searchKeyword": searchKeyword,
        "searchtypCd": "A",
        "radius": "0",
        "centerLon": String(longitude),
        "centerLat": String(latitude),
        "appKey": "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    ]}
}
