//
//  RoadService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import CoreLocation

struct  RoadService {
    let fetchSearchResult: (_ keyword: String, _ coordinate: CLLocationCoordinate2D) -> Observable<SearchResultDTO>
    let fetchRoute: (_ point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) -> Observable<RouteDTO>
    let fetchStartPointName: (_ point: CLLocationCoordinate2D) -> Observable<AddressDTO>
    let fetchServiceArea: (_ routeName: String) -> Observable<[ServiceAreaDTO]>
    let fetchGasStation: (_ routeName: String) -> Observable<[GasStationDTO]>
    let fetchGasPrice: (_ routeName: String) -> Observable<GasPriceDTO>
    
    init(fetchSearchResult: @escaping (_ keyword: String, _ coordinate: CLLocationCoordinate2D) -> Observable<SearchResultDTO>,
         fetchRoute: @escaping (_ point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) -> Observable<RouteDTO>,
         fetchStartPointName: @escaping(_ point: CLLocationCoordinate2D) -> Observable<AddressDTO>,
         fetchServiceArea: @escaping (_ routeName: String) -> Observable<[ServiceAreaDTO]>,
         fetchGasStation: @escaping (_ routeName: String) -> Observable<[GasStationDTO]>,
         fetchGasPrice: @escaping (_ routeName: String) -> Observable<GasPriceDTO>) {
        self.fetchSearchResult = fetchSearchResult
        self.fetchRoute = fetchRoute
        self.fetchStartPointName = fetchStartPointName
        self.fetchServiceArea = fetchServiceArea
        self.fetchGasStation = fetchGasStation
        self.fetchGasPrice = fetchGasPrice
    }
}

extension RoadService {
    static let live = Self(
        fetchSearchResult: { keyword, coordinate in
            return RouterManager<RoadAPI>
                .init()
                .request(router: .fetchSearchResult(keyword: keyword, coordinate: coordinate))
                .map { data in
                    do {
                        return try JSONDecoder().decode(SearchResultDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        },
        fetchRoute: { point in
            return RouterManager<RoadAPI>
                .init()
                .request(router: .fetchRoute(point: point))
                .map { data in
                    do {
                        return try JSONDecoder().decode(RouteDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        },
        fetchStartPointName: { point in
            return RouterManager<RoadAPI>
                .init()
                .request(router: .fetchStartPointName(point: point))
                .map { data in
                    do {
                        return try JSONDecoder().decode(AddressDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        },
        fetchServiceArea: { routeName in
            return RouterManager<RoadAPI>
                .init()
                .request(router: .fetchServiceArea(routeName: routeName))
                .map({ data in
                    let parser = ServiceAreaParser(data: data)
                    let decoded = parser.parseXML()
                    return decoded
                })
                .asObservable()
        },
        fetchGasStation: { routeName in
            return RouterManager<RoadAPI>
                .init()
                .request(router: .fetchGasStation(routeName: routeName))
                .map({ data in
                    let parser = GasStationParser(data: data)
                    let decoded = parser.parseXML()
                    return decoded
                })
                .asObservable()
        },
        fetchGasPrice: { serviceName in
            return RouterManager<RoadAPI>
                .init()
                .request(router: .fetchGasPrice(serviceName: serviceName))
                .map { data in
                    do {
                        return try JSONDecoder().decode(GasPriceDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        }
    )
}

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
