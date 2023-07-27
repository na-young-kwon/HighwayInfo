//
//  RoadServiceError.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/27.
//

import Foundation

struct RoadServiceError: Error {
    var code: Code
    var underlying: Error?
    
    enum Code: Int {
        case decodeFailed = 0
    }
    
    init(code: Code, underlying: Error? = nil) {
        self.code = code
        self.underlying = underlying
    }
}
