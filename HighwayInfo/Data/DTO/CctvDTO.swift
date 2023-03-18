//
//  CctvDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation

struct CctvDTO: Decodable {
    let response: Response
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct Response: Decodable {
    let coordType: Int
    let data: Cctv?
    let dataCount: Int
    
    enum CodingKeys: String, CodingKey {
        case coordType = "coordtype"
        case dataCount = "datacount"
        case data
    }
}

struct Cctv: Decodable {
     let roadSectionId: String
     let coordX: Double
     let coordY: Double
     let cctvResolution: String
     let fileCreateTime: String
     let cctvType: Int
     let cctvFormat: String
     let cctvName: String
    let cctvURL: String
    
    enum CodingKeys: String, CodingKey {
        case roadSectionId = "roadsectionid"
        case coordX = "coordx"
        case coordY = "coordy"
        case cctvResolution = "cctvresolution"
        case fileCreateTime = "filecreatetime"
        case cctvType = "cctvtype"
        case cctvFormat = "cctvformat"
        case cctvName = "cctvname"
        case cctvURL = "cctvurl"
    }
}
