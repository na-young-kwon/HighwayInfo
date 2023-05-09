//
//  FoodDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct FoodDTO: Decodable {
    let pageNo: String
    let numOfRows: String
    let serviceCode: String
    let serviceName: String
    let address: String
    let lastModifyUser: String
    let lastModifyDate: String
    let routeCd: String
    let routeNm: String
    let sequence: String
    let foodName: String
    let foodCost: String
    let etc: String
    let recommendYesOrNo: String
    let seasonMenu: String
    let bestFoodYesOrNo: String
    let premiumYesOrNo: String
    let app: String
    let restCd: String
    let foodMaterial: String
    let lastId: String
    let lastDtime: String
    
    enum CodingKeys: String, CodingKey {
        case serviceCode = "stdRestCd"
        case serviceName = "stdRestNm"
        case address = "svarAddr"
        case lastModifyUser = "lsttmAltrUser"
        case lastModifyDate = "lsttmAltrDttm"
        case sequence = "seq"
        case foodName = "foodNm"
        case recommendYesOrNo = "recommendyn"
        case bestFoodYesOrNo = "bestfoodyn"
        case premiumYesOrNo = "premiumyn"
        case pageNo, numOfRows, routeCd, routeNm, foodCost, etc, seasonMenu
        case app, restCd, foodMaterial, lastId, lastDtime
    }
}
