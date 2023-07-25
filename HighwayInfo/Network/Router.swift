//
//  Router.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/24.
//

import Alamofire
import Foundation

protocol Router {    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var task: Task { get }
}

enum Task {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestParameters(parameters: [String: Any])
}
