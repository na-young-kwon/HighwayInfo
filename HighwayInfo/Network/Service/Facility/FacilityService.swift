//
//  FacilityService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation
import RxSwift

final class FacilityService {
    let apiProvider: APIProvider
    
    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchFoodMenu(for serviceName: String) -> Observable<FoodDTO> {
        let request = FoodRequest(serviceName: serviceName)
        return apiProvider.performDataTask(with: request, decodeType: .json)
    }
    
    func fetchOilCompany(for serviceName: String) -> Observable<OilCompanyDTO> {
        let request = OilCompanyRequest(serviceAreaName: serviceName)
        return apiProvider.performDataTask(with: request, decodeType: .json)
    }
    
    func fetchBrandList(for serviceName: String) -> Observable<BrandListDTO> {
        let request = BrandListRequest(serviceAreaName: serviceName)
        return apiProvider.performDataTask(with: request, decodeType: .json)
    }
    
    func fetchConvenienceList(for serviceName: String) -> Observable<ConvenienceListDTO> {
        let request = ConvenienceListRequest(serviceAreaName: serviceName)
        return apiProvider.performDataTask(with: request, decodeType: .json)
    }
}
