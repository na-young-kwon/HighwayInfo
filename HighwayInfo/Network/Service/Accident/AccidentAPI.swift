//
//  NetworkAPI.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/24.
//

import Alamofire
import Foundation

enum AccidentAPI {
    case getAccidents
}

extension AccidentAPI: Router {
    var baseURL: URL {
        return URL(string: "http://openapigits.gg.go.kr/api/rest/")!
    }
    
    var path: String {
        switch self {
        case .getAccidents:
            return "getIncidentInfo?"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAccidents:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var task: Task {
        switch self {
        case .getAccidents:
            return .requestParameters(
                parameters: ["serviceKey": Bundle.main.accidentApiKey]
            )
        }
    }
}
