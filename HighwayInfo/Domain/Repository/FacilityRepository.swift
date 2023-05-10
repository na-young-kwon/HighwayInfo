//
//  FacilityRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation
import RxSwift

protocol FacilityRepository {
    func fetchFoodMenu(for serviceName: String) -> Observable<FoodDTO>
    func fetchOilCompany(for serviceName: String) -> Observable<OilCompanyDTO>
    func fetchBrandList(for serviceName: String) -> Observable<BrandListDTO>
}
