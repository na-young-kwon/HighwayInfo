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
            .map { $0.map { ServiceArea(name: $0.serviceAreaName,
                                        serviceAreaCode: $0.serviceAreaCode,
                                        convenience: $0.convenience,
                                        direction: $0.direction,
                                        address: $0.address,
                                        telNo: $0.telNo,
                                        gasStationCode: $0.gasStationCode) }
            }
            .subscribe(onNext: { serviceArea in
                self.serviceArea.onNext(serviceArea)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchGasStation(for routeName: String) {
        let serviceAreaCode = roadRepository.fetchGasStation(for: routeName)
            .map { $0.compactMap { $0.serviceAreaCode } }
        let gasStation = serviceAreaCode.flatMap { serviceCode in
            Observable.zip(
                serviceCode.map { self.roadRepository.fetchGasPrice(for: $0) }
            )}
        gasStation
            .take(15)
            .map { $0.map { GasStation(name: $0.name,
                                       address: $0.address,
                                       dieselPrice: $0.dieselPrice,
                                       gasolinePrice: $0.gasolinePrice,
                                       lpgPrice: $0.lpgPrice,
                                       serviceAreaCode: $0.serviceAreaCode)}
            }
            .subscribe(onNext: { gasStation in
                self.gasStation.onNext(gasStation)
            })
            .disposed(by: disposeBag)
    }
}
