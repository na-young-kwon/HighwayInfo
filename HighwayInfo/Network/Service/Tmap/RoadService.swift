//
//  RoadService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import CoreLocation

struct RouteCoordinate: Encodable {
    let startX: String
    let startY: String
    let endX: String
    let endY: String
}

final class RoadService {
    let apiProvider: APIProvider
    
    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchSearchResult(for keyword: String, coordinate: CLLocationCoordinate2D) -> Observable<SearchResultDTO> {
        let request = SearchRequest(searchKeyword: keyword,
                                    longitude: coordinate.longitude,
                                    latitude: coordinate.latitude)
        return apiProvider.performDataTask(with: request, decodeType: .json)
    }
    
    func fetchRoute(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) -> Observable<RouteDTO> {
        let request = RouteRequest()
        let data = RouteCoordinate(startX: String(point.0.longitude),
                                   startY: String(point.0.latitude),
                                   endX: String(point.1.longitude),
                                   endY: String(point.1.latitude))
        return apiProvider.performPostDataTask(data, with: request)
    }
}

