//
//  CctvDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation

struct CctvDTO: Decodable {
    private let roadsectionid: String
    private let coordx: Double
    private let coordy: Double
    private let cctvresolution: String
    private let filecreatetime: String
    private let cctvtype: Int
    private let cctvformat: String
    private let cctvname: String
    private let cctvurl: String
    
    init(roadsectionid: String,
         coordx: Double,
         coordy: Double,
         cctvresolution: String,
         filecreatetime: String,
         cctvtype: Int,
         cctvformat: String,
         cctvname: String,
         cctvurl: String) {
        
        self.roadsectionid = roadsectionid
        self.coordx = coordx
        self.coordy = coordy
        self.cctvresolution = cctvresolution
        self.filecreatetime = filecreatetime
        self.cctvtype = cctvtype
        self.cctvformat = cctvformat
        self.cctvname = cctvname
        self.cctvurl = cctvurl
    }
}
