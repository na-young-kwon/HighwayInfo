//
//  MockFacilityUseCase.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/03.
//

import Foundation
import RxSwift

final class MockFacilityUseCase: FacilityUseCase {
    var convenienceList = PublishSubject<[ConvenienceList]>()
    var foodMenuList = PublishSubject<[FoodMenu]>()
    var brandList = PublishSubject<[Brand]>()
    var gasStation = PublishSubject<GasStation>()
    
    func fetchConvenienceList(for service: ServiceArea) {
        let newConvenience = ConvenienceList(name: "천안호두(부산)휴게소",
                                             startTime: "00:00",
                                             endTime: "00:00")
        convenienceList.onNext([newConvenience])
    }
    
    func fetchFoodMenu(for service: ServiceArea) {
        let newFood =  FoodMenu(name: "해물된장찌개",
                                price: "8000")
        foodMenuList.onNext([newFood])
    }
    
    func fetchBrandList(for service: ServiceArea) {
        let newBrand =  Brand(name: "탐앤탐스",
                              startTime: "00:00",
                              endTime: "24:00")
        brandList.onNext([newBrand])
    }
    
    func fetchGasStation(for name: String) {
        gasStation.onNext(
            GasStation(uuid: "test_gas_uuid",
                       name: "화성(서울)주유소",
                       dieselPrice: "1,340원",
                       gasolinePrice: "1,520원",
                       lpgPrice: "X",
                       telNo: "055-312-2862",
                       oilCompany: "SK")
        )
    }
}
