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
            .subscribe(onNext: { serviceAreaDTO in
                print("serviceAreaDTO \(serviceAreaDTO.first?.serviceAreaName)")
            })
            .disposed(by: disposeBag)
    }
    
    func fetchGasStation(for routeName: String) {
        roadRepository.fetchGasStation(for: routeName)
            .map { $0.map { $0.name } }
            .subscribe(onNext: { gasStationDTO in
                print("gas \(Set(gasStationDTO))")
            })
            .disposed(by: disposeBag)
    }
}
