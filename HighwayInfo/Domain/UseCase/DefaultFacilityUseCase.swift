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
    var foodMenuList = PublishSubject<[FoodMenu]>()
    var convenienceList = PublishSubject<[ConvenienceList]>()
    var brandList = PublishSubject<[Brand]>()
    
    init(roadRepository: RoadRepository, facilityRepository: FacilityRepository) {
        self.roadRepository = roadRepository
        self.facilityRepository = facilityRepository
    }
    
    func fetchGasPrice(for serviceName: String) {
        roadRepository.fetchGasPrice(for: serviceName)
            .subscribe(onNext: { gasPriceDTO in
//                print(gasPriceDTO.name)
            })
            .disposed(by: disposeBag)
        
        facilityRepository.fetchOilCompany(for: serviceName)
            .subscribe(onNext: { oilDTO in
//                print("오일컴퍼니: \(oilDTO.companyName)")
            })
            .disposed(by: disposeBag)
    }
    
    func fetchConvenienceList(for serviceName: String) {
        facilityRepository.fetchConvenienceList(for: serviceName)
            .subscribe(onNext: { convenienceListDTO in
                self.convenienceList.onNext(convenienceListDTO.convenienceList)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchFoodMenu(for serviceName: String) {
        facilityRepository.fetchFoodMenu(for: serviceName)
            .subscribe(onNext: { foodDTO in 
                self.foodMenuList.onNext(foodDTO.foodMenuList)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchBrandList(for serviceName: String) {
        facilityRepository.fetchBrandList(for: serviceName)
            .subscribe(onNext: { brandListDTO in
                self.brandList.onNext(brandListDTO.brands)
            })
            .disposed(by: disposeBag)
    }
}
