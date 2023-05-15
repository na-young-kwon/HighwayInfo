//
//  DefaultResultUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultCardUseCase: CardUseCase {
    private let roadRepository: RoadRepository
    private let disposeBag = DisposeBag()
    
    var serviceArea = PublishSubject<[ServiceArea]>()
    var gasStation = PublishSubject<[GasStation]>()
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func fetchServiceArea(for routeName: String) {
        roadRepository.fetchServiceArea(for: routeName)
            .take(15)
            .map { $0.map { $0.toDomain } }
            .subscribe(onNext: { serviceArea in
                self.serviceArea.onNext(serviceArea)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchGasStation(for routeName: String) {
        let serviceAreaNames = roadRepository.fetchGasStation(for: routeName)
            .map { $0.compactMap { $0.name } }
        let gasStation = serviceAreaNames.flatMap { serviceName in
            Observable.zip(
                serviceName.map { self.roadRepository.fetchGasPrice(for: $0) }
            )}
        gasStation
            .take(15)
            .map { $0.compactMap { $0.toDomain } }
            .subscribe(onNext: { gasStation in
                self.gasStation.onNext(gasStation)
            })
            .disposed(by: disposeBag)
    }
}
