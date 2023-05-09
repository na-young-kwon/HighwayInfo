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
}
