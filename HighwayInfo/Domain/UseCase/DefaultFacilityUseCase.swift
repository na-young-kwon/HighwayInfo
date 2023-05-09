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
    private let disposeBag = DisposeBag()
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func fetchGasPrice(for name: String) {
        roadRepository.fetchGasPrice(for: name)
            .subscribe(onNext: { price in
                print(price.name)
            })
            .disposed(by: disposeBag)
    }
}
