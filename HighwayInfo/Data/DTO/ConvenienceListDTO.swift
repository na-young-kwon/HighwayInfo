//
//  ConvenienceListDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/10.
//

import Foundation

struct ConvenienceListDTO: Decodable {
    private let list: [Convenience]
    private let count: Int
    private let pageNo: Int
    private let numOfRows: Int
    private let pageSize: Int
    private let message: String
    private let code: String
    
    var convenienceList: [ConvenienceList] {
        if list.isEmpty {
            return []
        }
        return list.map { ConvenienceList(name: $0.name, startTime: $0.startTime, endTime: $0.endTime) }
    }
    
    struct Convenience: Decodable {
        let name: String
        private let psDesc: String?
        private let pageNo: String?
        private let numOfRows: String?
        private let stdRestCd: String
        private let stdRestNm: String
        let startTime: String
        let endTime: String
        private let redId: String
        private let redDtime: String
        private let lsttmAltrUser: String
        private let lsttmAltrDttm: String
        private let svarAddr: String
        private let routeCd: String
        private let routeNm: String
        private let psCode: String
        
        enum CodingKeys: String, CodingKey {
            case name = "psName"
            case startTime = "stime"
            case endTime = "etime"
            case psDesc, pageNo, numOfRows, stdRestCd, stdRestNm, psCode
            case redId, redDtime, lsttmAltrUser, lsttmAltrDttm, svarAddr, routeCd, routeNm
        }
    }
}
