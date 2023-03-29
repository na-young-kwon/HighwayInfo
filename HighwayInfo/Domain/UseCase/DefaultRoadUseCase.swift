//
//  DefaultRoadUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultRoadUseCase: RoadUseCase {
    private let roadRepository: RoadRepository
    private let disposeBag = DisposeBag()
    let route: Route
    var roads = BehaviorSubject<[RoadDetail]>(value: [])
    
    init(route: Route, roadRepository: RoadRepository) {
        self.route = route
        self.roadRepository = roadRepository
    }
    
    func fetchLocationInfo() {
        roadRepository.fetchLocationInfo(for: route)
            .map { $0.map {
                RoadDetail(name: $0.icName, coordx: $0.coordx, coordy: $0.coordy, preview: nil)
            }}
            .subscribe(onNext: { roadDetails in
                self.roads.onNext(roadDetails)
            })
            .disposed(by: disposeBag)
    }
}
