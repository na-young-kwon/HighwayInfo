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
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func searchRoute(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D)) {
        let result = roadRepository.fetchRoute(for: point).map { $0.features.flatMap { $0.geometry.coordinates }}
        result
            .map { $0.compactMap { $0.point } }
            .subscribe(onNext: { route in
                let latitude = route.filter { $0 < 100 }
                let longitude = route.filter { $0 > 100 }
                let coordinate = zip(latitude, longitude)
                let path = coordinate.map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1)}
                self.path.onNext(path)
            })
            .disposed(by: disposeBag)
    }
}
