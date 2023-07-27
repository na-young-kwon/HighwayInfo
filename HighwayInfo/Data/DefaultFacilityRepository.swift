//
//  DefaultFacilityRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation
import RxSwift

final class DefaultFacilityRepository: FacilityRepository {
    private let service: FacilityService
    
    init(service: FacilityService) {
        self.service = service
    }
    
    func fetchFoodMenu(for serviceName: String) -> Observable<FoodDTO> {
        return service.fetchFoodMenu(serviceName)
    }
    
    func fetchOilCompany(for serviceName: String) -> Observable<OilCompanyDTO> {
        return service.fetchOilCompany(serviceName)
    }
    
    func fetchBrandList(for serviceName: String) -> Observable<BrandListDTO> {
        return service.fetchBrandList(serviceName)
    }
    
    func fetchConvenienceList(for serviceName: String) -> Observable<ConvenienceListDTO> {
        return service.fetchConvenienceList(serviceName)
    }
}
