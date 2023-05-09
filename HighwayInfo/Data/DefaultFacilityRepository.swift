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
        return service.fetchFoodMenu(for: serviceName)
    }
}
