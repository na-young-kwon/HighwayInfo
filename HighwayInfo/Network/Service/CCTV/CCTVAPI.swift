//
//  CCTVAPI.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/25.
//

import Alamofire
import Foundation

enum CCTVAPI {
    case fetchPreviewBy(Double, Double)
    case fetchVideoBy(Double, Double)
}

extension CCTVAPI: Router {
    var baseURL: URL {
        return URL(string: "https://openapi.its.go.kr:9443/")!
    }
    
    var path: String {
        return "cctvInfo"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        switch self {
        case .fetchPreviewBy(let x, let y):
            return .requestParameters(
                parameters:
                    [ "apiKey": Bundle.main.cctvApiKey,
                      "type": "ex",
                      "cctvType": "3",
                      "minX": String(x - 0.006),
                      "maxX": String(x + 0.006),
                      "minY": String(y - 0.006),
                      "maxY": String(y + 0.006),
                      "getType": "xml"
                    ])
            
        case .fetchVideoBy(let x, let y):
            return .requestParameters(
                parameters:
                    ["apiKey": Bundle.main.cctvApiKey,
                     "type": "ex",
                     "cctvType": "2",
                     "minX": String(x - 0.006),
                     "maxX": String(x + 0.006),
                     "minY": String(y - 0.006),
                     "maxY": String(y + 0.006),
                     "getType": "xml"
                    ])
        }
    }
}
