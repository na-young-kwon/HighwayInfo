//
//  RoadService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation
import RxSwift

final class RoadService {
    let apiProvider: APIProvider
    let apiKey = "952f3149f2bac24e515f8fb0b84bcc14ba2edc"
    
    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchAllAccidents() -> Observable<[AccidentDTO]> {
        let request = AccidentRequest()
        return apiProvider.performDataTask(with: request, decodeType: .xml)
    }
}
