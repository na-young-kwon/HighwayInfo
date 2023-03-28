//
//  RoadService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift

final class RoadService {
    let apiProvider: APIProvider
    
    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchLocationInfo(for route: Route) -> Observable<[RoadDTO]> {
        let request = RoadRequest(routeNo: route.number)
        let result = apiProvider.performDataTask(with: request, decodeType: .json)
        return result
    }
}
