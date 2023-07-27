//
//  RouterManagerError.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/24.
//

import Foundation
import Alamofire
import RxSwift

struct RouterManagerError: Error {
    var code: Code
    var underlying: Error?
    var errorBody: String?
    
    enum Code: Int {
        case failedRequest = 0
        case isNotSuccessful = 1
    }
    
    init(code: Code,
         underlying: Error? = nil,
         response: AFDataResponse<Data>? = nil) {
        self.code = code
        self.underlying = underlying
        
        if let data = response?.data {
            self.errorBody = try? JSONDecoder().decode(String.self, from: data)
        }
    }
}
