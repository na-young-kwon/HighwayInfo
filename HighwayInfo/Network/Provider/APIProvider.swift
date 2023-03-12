//
//  APIProvider.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation
import RxSwift

protocol APIProvider {
    var session: URLSession { get }
    
    func performDataTask<T: APIRequest>(with requestType: T, decodeType: DecodeType) -> Observable<T.Response>
}
