//
//  NetworkError.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/07.
//

import Foundation

enum NetworkingError: Error {
    case serverError
    case invalidResponse
    case invalidData
    case invalidRequest
    case convertToReponseError
    case parsingError
}
