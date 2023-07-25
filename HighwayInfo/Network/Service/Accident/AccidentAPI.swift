//
//  NetworkAPI.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/24.
//

import Alamofire
import Foundation

enum AccidentAPI {
    typealias Response = [AccidentDTO]
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
    
    var task: Task {
        switch self {
        case .getAccidents:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["serviceKey": Bundle.main.accidentApiKey]
    }
}
