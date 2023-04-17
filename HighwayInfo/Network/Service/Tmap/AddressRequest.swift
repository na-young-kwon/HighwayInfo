//
//  AddressRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/17.
//

import Foundation

struct AddressRequest: APIRequest {
    typealias Response = AddressDTO
        
    let httpMethod: HTTPMethod = .get
    let urlHost = "https://apis.openapi.sk.com/tmap/geo/"
    let urlPath = "reversegeocoding?"
    let version = "1"
    let latitude: Double
    let longitude: Double
    
    
    var parameters: [String : String] {[
        "version": version,
        "lat": String(latitude),
        "lon": String(longitude),
        "appKey": "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    ]}
}
