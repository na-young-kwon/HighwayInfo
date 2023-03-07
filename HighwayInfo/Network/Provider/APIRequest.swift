//
//  APIRequest.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation

protocol APIRequest {
    associatedtype Response: APIResponse

    var method: HTTPMethod { get }
    var baseURL: URL? { get }
    var path: String { get }
    var url: URL? { get }
    var parameters: [String: String] { get }
    var headers: [String: String]? { get }
}

extension APIRequest {
    var url: URL? {
        guard let url = self.baseURL?.appendingPathComponent(self.path) else {
            return nil
        }
        var urlComponents = URLComponents(string: url.absoluteString)
        let urlQueries = self.parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        urlComponents?.percentEncodedQueryItems = urlQueries

        return urlComponents?.url
    }

    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        if let headers = self.headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }
}
