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
    var isReverse = BehaviorRelay<Bool>(value: false)
    var roads = BehaviorSubject<[RoadDetail]>(value: [])
    
    init(route: Route, roadRepository: RoadRepository) {
        self.route = route
        self.roadRepository = roadRepository
    }
    
    func fetchLocationInfo() {
        let road = roadRepository.fetchLocationInfo(for: route)
        
        Observable.combineLatest(isReverse, road)
            .map { self.filterRoad(for: self.route.axis, info: $1) }
            .subscribe(onNext: { roadDetails in
                self.roads.onNext(roadDetails)
            })
            .disposed(by: disposeBag)
    }
    
    private func filterRoad(for axis: Route.Axis, info: LocationInfo) -> [RoadDetail] {
        var roads: [RoadDTO] = []
        
        isReverse.subscribe(onNext: { reverse in
            if axis == .vertical {
                roads = info.list.sorted(by: { reverse ? $0.coordy < $1.coordy : $0.coordy > $1.coordy })
            } else {
                roads = info.list.sorted(by: { reverse ? $0.coordx > $1.coordx : $0.coordx < $1.coordx })
            }
        })
        .disposed(by: disposeBag)
       
        return roads.map { RoadDetail(name: $0.icName, coordx: $0.coordx, coordy: $0.coordy, preview: nil) }
    }
}
