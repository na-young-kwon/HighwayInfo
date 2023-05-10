//
//  BrandListDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct BrandListDTO: Decodable {
    private let list: [BrandList]
    private let count: Int
    private let pageNo: Int
    private let numOfRows: Int
    private let pageSize: Int
    private let message: String
    private let code: String
    
    var brands: [Brand]? {
        if list.isEmpty {
            return nil
        }
        return list.map { Brand(name: $0.brandName, startTime: $0.startTime, endTime: $0.endTime) }
    }
    
    struct BrandList: Decodable {
        let brandName: String
        let startTime: String
        let endTime: String
        private let pageNo: String?
        private let numOfRows: String?
        private let stdRestCd: String
        private let stdRestNm: String
        private let brdCode: String
        private let brdDesc: String
        private let redId: String
        private let redDtime: String
        private let lsttmAltrUser: String
        private let lsttmAltrDttm: String
        private let svarAddr: String
        private let routeCd: String
        private let routeNm: String
        
        enum CodingKeys: String, CodingKey {
            case brandName = "brdName"
            case startTime = "stime"
            case endTime = "etime"
            case pageNo, numOfRows, stdRestCd, stdRestNm, brdCode, brdDesc
            case redId, redDtime, lsttmAltrUser, lsttmAltrDttm, svarAddr, routeCd, routeNm
        }
    }
}
