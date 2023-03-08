//
//  NetworkReqiest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    
    var httpMethod: HTTPMethod { get }
    var urlHost: String { get }
    var urlPath: String { get }
    var parameters: [String: String] { get }
}

extension APIRequest {
    var urlComponents: URL? {
        var urlComponents = URLComponents(string: self.urlHost + self.urlPath)
        let queries = self.parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents?.queryItems = queries
        
        guard let url = urlComponents?.url else {
            return nil
        }
        return url
    }
    
    var urlRequest: URLRequest? {
        guard let urlComponents = urlComponents else {
            return nil
        }
        var request = URLRequest(url: urlComponents)
        request.httpMethod = self.httpMethod.rawValue

        return request
    }
}
