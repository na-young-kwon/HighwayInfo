//
//  FoodDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation

struct FoodDTO: Decodable {
    private let list: [Food]
    private let count: Int
    private  let numOfRows: Int
    private let pageSize: Int
    private let message: String
    private let code: String
    
    var foodMenuList: [FoodMenu] {
        if list.isEmpty {
            return []
        }
        return list.map { FoodMenu(name: $0.foodName, price: $0.foodCost) }
    }
    
    struct Food: Decodable {
        private let pageNo: String?
        private let numOfRows: String?
        private let serviceCode: String
        private let serviceName: String
        private let address: String
        private let lastModifyUser: String
        private let lastModifyDate: String
        private let routeCd: String
        private let routeNm: String
        private let sequence: String
        let foodName: String
        let foodCost: String
        private let etc: String?
        private let recommendYesOrNo: String
        private let seasonMenu: String
        private let bestFoodYesOrNo: String
        private let premiumYesOrNo: String
        private let app: String
        private let restCd: String
        private let foodMaterial: String?
        private let lastId: String
        private let lastDtime: String
        
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

}
