//
//  FacilityAPI.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/26.
//

import Alamofire
import Foundation

enum FacilityAPI {
    case fetchFoodMenu(serviceName: String)
    case fetchOilCompany(serviceName: String)
    case fetchBrandList(serviceName: String)
    case fetchConvenienceList(serviceName: String)
}

extension FacilityAPI: Router {
    var baseURL: URL {
        switch self {
        case .fetchFoodMenu, .fetchBrandList, .fetchConvenienceList:
            return URL(string: "http://data.ex.co.kr/openapi/restinfo/")!
        case .fetchOilCompany:
            return URL(string: "http://data.ex.co.kr/openapi/business/")!
        }
    }
    
    var path: String {
        switch self {
        case .fetchFoodMenu:
            return "restBestfoodList?"
        case .fetchOilCompany:
            return "lpgServiceAreaInfo?"
        case .fetchBrandList:
            return "restBrandList?"
        case .fetchConvenienceList:
            return "restConvList?"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var task: Task {
        switch self {
        case .fetchFoodMenu(let serviceName):
            return .requestParameters(
                parameters:
                    ["key": Bundle.main.serviceAreaKey,
                     "type": "json",
                     "numOfRows": "10",
                     "stdRestNm": serviceName
                    ])
            
        case .fetchOilCompany(let serviceName):
            return .requestParameters(
                parameters:
                    ["key": Bundle.main.serviceAreaKey,
                     "type": "json",
                     "serviceAreaName": serviceName
                    ])
            
        case .fetchBrandList(let serviceName):
            return .requestParameters(
                parameters:
                    ["key": Bundle.main.serviceAreaKey,
                     "type": "json",
                     "stdRestNm": serviceName
                    ])
            
        case .fetchConvenienceList(let serviceName):
            return .requestParameters(
                parameters:
                    ["key": Bundle.main.serviceAreaKey,
                     "type": "json",
                     "stdRestNm": serviceName
                    ])
        }
    }
}
