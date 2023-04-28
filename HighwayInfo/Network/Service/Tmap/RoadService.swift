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
    let searchOption = "4"
    let mainRoadInfo = "Y"
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
    
    func fetchStartPointName(for point: CLLocationCoordinate2D) -> Observable<AddressDTO> {
        let request = AddressRequest(latitude: point.latitude, longitude: point.longitude)
        return apiProvider.performDataTask(with: request, decodeType: .json)
    }
    
    func fetchServiceArea(for routeName: String) -> Observable<[ServiceAreaDTO]> {
        let request = ServiceAreaRequest(routeName: routeName)
        return apiProvider.performDataTask(with: request, decodeType: .serviceArea)
    }
    
    func fetchGasStation(for routeName: String) -> Observable<[GasStationDTO]> {
        let request = GasStationRequest(routeNm: routeName)
        return apiProvider.performDataTask(with: request, decodeType: .gasStation)
    }
}
