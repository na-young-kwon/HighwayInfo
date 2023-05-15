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
    var gasStation = PublishSubject<GasStation>()
    
    init(roadRepository: RoadRepository, facilityRepository: FacilityRepository) {
        self.roadRepository = roadRepository
        self.facilityRepository = facilityRepository
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
    
    func fetchGasStation(for serviceName: String) {
        let gasPrice = roadRepository.fetchGasPrice(for: serviceName).compactMap { $0.gasStation }
        let oilCompany = facilityRepository.fetchOilCompany(for: serviceName)
        Observable.zip(gasPrice, oilCompany)
            .map { GasStation(name: $0.0.name,
                              dieselPrice: $0.0.diselPrice,
                              gasolinePrice: $0.0.gasolinePrice,
                              lpgPrice: $0.0.lpgPrice,
                              telNo: $0.0.telNo,
                              oilCompany: $0.1.companyName
            )}
            .subscribe(onNext: { gasStation in
                self.gasStation.onNext(gasStation)
            })
            .disposed(by: disposeBag)
        
    }
}
