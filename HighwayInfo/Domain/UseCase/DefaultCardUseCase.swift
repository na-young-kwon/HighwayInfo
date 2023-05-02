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
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func fetchServiceArea(for routeName: String) {
        roadRepository.fetchServiceArea(for: routeName)
            .take(15)
            .subscribe(onNext: { serviceAreaDTO in
                print("serviceAreaDTO \(serviceAreaDTO.first?.serviceAreaName)")
            })
            .disposed(by: disposeBag)
    }
    
    func fetchGasStation(for routeName: String) {
        let serviceAreaCode = roadRepository.fetchGasStation(for: routeName)
            .map { $0.compactMap { $0.serviceAreaCode } }
        
        let gasStation = serviceAreaCode.flatMap { serviceCode in
            Observable.zip(
                serviceCode.map { self.roadRepository.fetchGasPrice(for: $0) }
            )
        }
        
        gasStation
            .take(15)
            .map { $0.map { $0.name } }
            .subscribe(onNext: { gasStation in
                print("gasStation \(gasStation)")
            })
            .disposed(by: disposeBag)
    }
}
