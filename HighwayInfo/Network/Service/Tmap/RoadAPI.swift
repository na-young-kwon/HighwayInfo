//
//  RoadAPI.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/26.
//

import Alamofire
import Foundation
import CoreLocation

struct RouteCoordinate: Encodable {
    let startX: String
    let startY: String
    let endX: String
    let endY: String
    let searchOption = "4"
    let mainRoadInfo = "Y"
}

enum RoadAPI {
    case fetchSearchResult(keyword: String, coordinate: CLLocationCoordinate2D)
    case fetchRoute(point: (CLLocationCoordinate2D, CLLocationCoordinate2D))
    case fetchStartPointName(point: CLLocationCoordinate2D)
    case fetchServiceArea(routeName: String)
    case fetchGasStation(routeName: String)
    case fetchGasPrice(serviceName: String)
}

extension RoadAPI: Router {
    var baseURL: URL {
        switch self {
        case .fetchSearchResult:
            return URL(string: "https://apis.openapi.sk.com/tmap/")!
        case .fetchRoute:
            return URL(string: "https://apis.openapi.sk.com/tmap/")!
        case .fetchStartPointName:
            return URL(string: "https://apis.openapi.sk.com/tmap/geo/")!
        case .fetchServiceArea:
            return URL(string: "http://data.ex.co.kr/openapi/business/")!
        case .fetchGasStation:
            return URL(string: "http://data.ex.co.kr/openapi/restinfo/")!
        case .fetchGasPrice:
            return URL(string: "http://data.ex.co.kr/openapi/business/")!
        }
    }
    
    var path: String {
        switch self {
        case .fetchSearchResult:
            return "pois?"
        case .fetchRoute:
            return "routes?"
        case .fetchStartPointName:
            return "reversegeocoding?"
        case .fetchServiceArea:
            return "serviceAreaRoute?"
        case .fetchGasStation:
            return "restOilList?"
        case .fetchGasPrice:
            return "curStateStation?"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchSearchResult, .fetchStartPointName,
                .fetchServiceArea, .fetchGasStation, .fetchGasPrice:
            return .get
        case .fetchRoute:
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchSearchResult, .fetchStartPointName,
                .fetchServiceArea, .fetchGasStation, .fetchGasPrice:
            return nil
        case .fetchRoute:
            return ["Content-Type": "application/json",
                    "appKey": "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"]
        }
    }
    
    var task: Task {
        switch self {
        case .fetchSearchResult(let keyword, let coordinate):
            return .requestParameters(
                parameters:
                    ["version": "2.12",
                     "searchKeyword": keyword,
                     "searchtypCd": "A",
                     "radius": "0",
                     "centerLon": String(coordinate.longitude),
                     "centerLat": String(coordinate.latitude),
                     "appKey": Bundle.main.tmapApiKey
                    ])
        case .fetchRoute(let point):
            let data = RouteCoordinate(startX: String(point.0.longitude),
                                       startY: String(point.0.latitude),
                                       endX: String(point.1.longitude),
                                       endY: String(point.1.latitude))
            return .requestJSONEncodable(data)
        case .fetchStartPointName(let point):
            return .requestParameters(
                parameters:
                    ["version": "1",
                     "lat": String(point.latitude),
                     "lon": String(point.longitude),
                     "appKey": Bundle.main.tmapApiKey
                    ])
        case .fetchServiceArea(let routeName):
            return .requestParameters(
                parameters:
                    ["key": Bundle.main.serviceAreaKey,
                     "type": "xml",
                     "numOfRows": "15",
                     "routeName": routeName
                    ])
        case .fetchGasStation(let routeName):
            return .requestParameters(
                parameters:
                    ["key": Bundle.main.serviceAreaKey,
                     "type": "xml",
                     "routeNm": routeName
                    ])
        case .fetchGasPrice(let serviceName):
            return .requestParameters(
                parameters:
                    ["key": Bundle.main.serviceAreaKey,
                     "type": "json",
                     "serviceAreaName": serviceName
                    ])
        }
    }
}
