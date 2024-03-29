//
//  DefaultSearchUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

final class DefaultSearchUseCase: SearchUseCase {
    private let roadRepository: RoadRepository
    private let userRepository: UserRepository
    private let locationService: DefaultLocationService
    private let disposeBag = DisposeBag()
    private var path = PublishSubject<[CLLocationCoordinate2D]>()
    private var highwayInfo = PublishSubject<[HighwayInfo]>()
    var searchResult = PublishSubject<[LocationInfo]>()
    var searchHistory = PublishSubject<[LocationInfo]>()
    var route = PublishSubject<Route>()
    
    init(roadRepository: RoadRepository, userRepository: UserRepository, locationService: DefaultLocationService) {
        self.roadRepository = roadRepository
        self.userRepository = userRepository
        self.locationService = locationService
    }
    
    func fetchSearchHistory() {
        userRepository.fetchSearchHistory()
            .subscribe(onNext: { [weak self] location in
                self?.searchHistory.onNext(location)
            })
            .disposed(by: disposeBag)
    }
    
    func saveSearchTerm(with location: LocationInfo) {
        userRepository.saveHistory(with: location)
    }
    
    func deleteSearchHistory() {
        userRepository.deleteAll()
        searchHistory.onNext([])
    }
    
    func fetchResult(for keyword: String, coordinate: CLLocationCoordinate2D) {
        roadRepository.fetchSearchResult(for: keyword, coordinate: coordinate)
            .map { $0.toDomain }
            .subscribe(onNext: { [weak self] searchResult in
                self?.searchResult.onNext(searchResult)
            })
            .disposed(by: disposeBag)
    }
    
    func searchRoute(for point: (start: CLLocationCoordinate2D, end: CLLocationCoordinate2D), endPointName: String) {
        fetchPath(for: point)
        fetchHighway(for: point)
       let currentLocation = roadRepository.fetchStartPointName(for: point.start)
        
        Observable.zip(path, highwayInfo, currentLocation)
            .subscribe(onNext: { [weak self] path, highwayInfo, startPointName in
                let route = Route(startPointName: startPointName,
                                  endPointName: endPointName,
                                  path: path,
                                  markerPoint: point,
                                  highwayInfo: highwayInfo)
                self?.route.onNext(route)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchPath(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) {
        let route = roadRepository.fetchRoute(for: point).map { $0.features.filter { $0.properties.pointType != "rs6" } }
        let coordinate = route.map { $0.flatMap { $0.geometry.coordinates } }.map { $0.compactMap { $0.point } }
        
        coordinate
            .subscribe(onNext: { [weak self] route in
                let latitude = route.filter { $0 < 100 }
                let longitude = route.filter { $0 > 100 }
                let coordinate = zip(latitude, longitude)
                let path = coordinate.map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1) }
                self?.path.onNext(path)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchHighway(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) {
        let highway = roadRepository
            .fetchRoute(for: point)
            .map { $0.features.filter { $0.properties.pointType == "rs6" && $0.properties.name.contains("고속도로") } }.share()
        let names = highway.map { $0.map { $0.properties.name } }
        let coordinates = highway
            .map { $0.map { $0.geometry.coordinates } }
            .map { $0.map { $0.compactMap { $0.point } } }
        
        Observable.zip(names, coordinates)
            .subscribe(onNext: { [weak self] element in
                guard let self = self else { return }
                if element.0.count > 0 {
                    let highwayInfo = self.makeHighwayInfo(names: element.0, coordinates: element.1)
                    self.highwayInfo.onNext(highwayInfo)
                } else {
                    self.highwayInfo.onNext([])
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func makeHighwayInfo(names: [String], coordinates: [[Double]]) -> [HighwayInfo] {
        let name = Observable.of(names)
        let coordinate = Observable.of(coordinates)
        let index = names.count
        var highwayInfo: [HighwayInfo] = []
        
        Observable.zip(name, coordinate)
            .subscribe(onNext: { name, coordinate in
                for i in 0...index - 1 {
                    highwayInfo.append(HighwayInfo(name: name[i], coordinate: coordinate[i]))
                }
            })
            .disposed(by: disposeBag)
        return highwayInfo
    }
}
