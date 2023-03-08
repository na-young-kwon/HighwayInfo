//
//  NetworkError.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation

enum NetworkingError: Error {
    case serverError
    case invalidResponse
    case invalidData
    case invalidRequest
    case parsingError
}
