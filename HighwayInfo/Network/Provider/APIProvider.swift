//
//  APIProvider.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation

protocol APIProvider {
    var session: URLSession { get }
    func request<T: APIRequest>(
        _ request: T,
        completion: @escaping (Result<T.Response, NetworkingError>) -> Void
    )
}
