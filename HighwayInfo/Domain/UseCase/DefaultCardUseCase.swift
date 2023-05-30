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
    
    func fetchService(for highway: HighwayInfo) {
        fetchServiceArea(for: highway)
        fetchGasStation(for: highway)
    }
    
    private func fetchServiceArea(for highway: HighwayInfo) {
        if let cachedServiceArea = CacheManager.shared.fetchServiceArea(for: highway.uuid) {
            serviceArea.onNext(cachedServiceArea)
        } else {
            roadRepository.fetchServiceArea(for: highway.rawName)
                .take(15)
                .map { $0.map { $0.toDomain } }
                .subscribe(onNext: { [weak self] serviceArea in
                    self?.serviceArea.onNext(serviceArea)
                    CacheManager.shared.saveServiceArea(data: serviceArea, for: highway.uuid)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func fetchGasStation(for highway: HighwayInfo) {
        if let cachedGasStation = CacheManager.shared.fetchGasStation(for: highway.uuid) {
            gasStation.onNext(cachedGasStation)
        } else {
            let serviceAreaNames = roadRepository.fetchGasStation(for: highway.rawName)
                .map { $0.compactMap { $0.name } }.share()
            serviceAreaNames
                .subscribe(onNext: { [weak self] gasStation in
                    if gasStation.isEmpty {
                        self?.gasStation.onNext([])
                    }
                })
                .disposed(by: disposeBag)
            
            let gasStation = serviceAreaNames.flatMap { [weak self] serviceName in
                Observable.zip(
                    serviceName.map { self!.roadRepository.fetchGasPrice(for: $0) }
                )}
            gasStation
                .take(15)
                .map { $0.compactMap { $0.toDomain } }
                .subscribe(onNext: { [weak self] gasStation in
                    self?.gasStation.onNext(gasStation)
                    CacheManager.shared.saveGasStation(data: gasStation, for: highway.uuid)
                })
                .disposed(by: disposeBag)
        }
    }
}
