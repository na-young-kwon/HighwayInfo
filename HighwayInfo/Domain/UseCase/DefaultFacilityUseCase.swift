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
    
    func fetchGasPrice(for serviceName: String) {
        roadRepository.fetchGasPrice(for: serviceName)
            .subscribe(onNext: { gasPriceDTO in
                print(gasPriceDTO.name)
            })
            .disposed(by: disposeBag)
        
        facilityRepository.fetchOilCompany(for: serviceName)
            .subscribe(onNext: { oilDTO in
                print("오일컴퍼니: \(oilDTO.companyName)")
            })
            .disposed(by: disposeBag)
        
        facilityRepository.fetchBrandList(for: serviceName)
            .subscribe(onNext: { brandListDTO in
                print("브랜드리스트: \(brandListDTO.brands)")
            })
            .disposed(by: disposeBag)
        
        facilityRepository.fetchConvenienceList(for: serviceName)
            .subscribe(onNext: { convenienceListDTO in
                print("편의시설리스트: \(convenienceListDTO.convenienceList)")
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
