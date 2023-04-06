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
    
    var parameters: [String : String] {[
        "version": version,
        "searchKeyword": searchKeyword,
        "appKey": "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    ]}
}
