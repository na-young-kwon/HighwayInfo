//
//  MockSearchUseCase.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import Foundation
import RxSwift
import CoreLocation

final class MockSearchUseCase: SearchUseCase {
    var searchResult = PublishSubject<[LocationInfo]>()
    var searchHistory = PublishSubject<[LocationInfo]>()
    var route = PublishSubject<Route>()
    
    func fetchSearchHistory() {
        searchHistory.onNext([LocationInfo(
            uuid: "test_id",
            name: "botanic",
            businessName: "eroom",
            distance: "10",
            coordx: "10",
            coordy: "10",
            address: nil
        )])
    }
    
    func deleteSearchHistory() {}
    
    func saveSearchTerm(with highwayInfo: LocationInfo) {}
    
    func fetchResult(for keyword: String, coordinate: CLLocationCoordinate2D) {
        searchResult.onNext([LocationInfo(
            uuid: "test_id",
            name: "newLocation",
            businessName: "eroom",
            distance: "10",
            coordx: "10",
            coordy: "10",
            address: nil
        )])
    }
    
    func searchRoute(for point: (start: CLLocationCoordinate2D, end: CLLocationCoordinate2D), endPointName: String) {
        let coordinate = CLLocationCoordinate2D(latitude: 37, longitude: 127)
        let highway = HighwayInfo(name: "test", coordinate: [10])
        route.onNext(Route(
            startPointName: "test",
            endPointName: "test",
            path: [coordinate],
            markerPoint: (coordinate, coordinate),
            highwayInfo: [highway]
        ))
    }
}
