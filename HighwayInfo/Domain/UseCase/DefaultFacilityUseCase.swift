//
//  DefaultFacilityUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultFacilityUseCase: FacilityUseCase {
    private let roadRepository: RoadRepository
    private let facilityRepository: FacilityRepository
    private let disposeBag = DisposeBag()
    
    init(roadRepository: RoadRepository, facilityRepository: FacilityRepository) {
        self.roadRepository = roadRepository
        self.facilityRepository = facilityRepository
    }
    
    func fetchGasPrice(for name: String) {
        roadRepository.fetchGasPrice(for: name)
            .subscribe(onNext: { price in
                print(price.name)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchFoodMenu(for serviceName: String) {
        facilityRepository.fetchFoodMenu(for: serviceName)
            .subscribe(onNext: { foodDto in
                print(foodDto.list)
            })
            .disposed(by: disposeBag)
    }
}
