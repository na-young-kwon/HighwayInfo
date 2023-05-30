//
//  FacilityUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation
import RxSwift

protocol FacilityUseCase {
    var foodMenuList: PublishSubject<[FoodMenu]> { get }
    var convenienceList: PublishSubject<[ConvenienceList]> { get }
    var brandList: PublishSubject<[Brand]> { get }
    var gasStation: PublishSubject<GasStation> { get }
    func fetchConvenienceList(for service: ServiceArea)
    func fetchFoodMenu(for service: ServiceArea)
    func fetchBrandList(for service: ServiceArea)
    func fetchGasStation(for name: String)
}
