//
//  AccidentService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation
import RxSwift

final class AccidentService {
    let apiProvider: APIProvider
    
    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchAllAccidents() -> Observable<[AccidentDTO]> {
        let request = AccidentRequest()
        return apiProvider.performDataTask(with: request, decodeType: .xml)
    }
}
