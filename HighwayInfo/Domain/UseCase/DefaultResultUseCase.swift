//
//  DefaultResultUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

final class DefaultResultUseCase: ResultUseCase {
    private let roadRepository: RoadRepository
    private let disposeBag = DisposeBag()
    var path = PublishSubject<[CLLocationCoordinate2D]>()
    var highwayName = PublishSubject<String?>()
    var highwayInfo = PublishSubject<[HighwayInfo]>()
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func searchRoute(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) {
        let route = roadRepository.fetchRoute(for: point).map { $0.features.filter { $0.properties.pointType != "rs6" }}
        let coordinate = route.map { $0.flatMap { $0.geometry.coordinates } }.map { $0.compactMap { $0.point } }
        coordinate
            .subscribe(onNext: { route in
                let latitude = route.filter { $0 < 100 }
                let longitude = route.filter { $0 > 100 }
                let coordinate = zip(latitude, longitude)
                let path = coordinate.map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1) }
                self.path.onNext(path)
            })
            .disposed(by: disposeBag)
    }
    
    func highway(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) {
        let highway = roadRepository
            .fetchRoute(for: point)
            .map { $0.features.filter { $0.properties.pointType == "rs6" && $0.properties.name.contains("고속도로")}}
            .share()
        let names = highway.map { $0.map { $0.properties.name } }
        let coordinates = highway
            .map { $0.map { $0.geometry.coordinates } }
            .map { $0.map { $0.compactMap { $0.point } } }
        
        Observable.zip(names, coordinates)
            .subscribe(onNext: { element in
                if element.0.count > 0 {
                    let highwayInfo = self.makeHighwayInfo(element: element)
                    self.highwayInfo.onNext(highwayInfo)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func makeHighwayInfo(element: ([String], [[Double]])) -> [HighwayInfo] {
        let name = Observable.of(element.0)
        let coordinate = Observable.of(element.1)
        let index = element.0.count
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