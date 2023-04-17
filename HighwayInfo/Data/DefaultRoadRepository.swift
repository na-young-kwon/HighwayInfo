//
//  DefaultRoadRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import CoreLocation

final class DefaultRoadRepository: RoadRepository {
    private let service: RoadService
    
    init(service: RoadService) {
        self.service = service
    }
    
    func fetchSearchResult(for keyword: String, coordinate: CLLocationCoordinate2D) -> Observable<SearchResultDTO> {
        service.fetchSearchResult(for: keyword, coordinate: coordinate)
    }
    
    func fetchRoute(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) -> Observable<RouteDTO> {
        service.fetchRoute(for: point)
    }
}
