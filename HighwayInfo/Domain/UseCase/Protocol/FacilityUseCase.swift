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
    func fetchGasPrice(for name: String)
    func fetchFoodMenu(for serviceName: String)
    func fetchBrandList(for serviceName: String)
}
