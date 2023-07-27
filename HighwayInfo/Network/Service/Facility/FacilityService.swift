//
//  FacilityService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation
import RxSwift

struct FacilityService {
    let fetchFoodMenu: (_ serviceName: String) -> Observable<FoodDTO>
    let fetchOilCompany: (_ serviceName: String) -> Observable<OilCompanyDTO>
    let fetchBrandList: (_ serviceName: String) -> Observable<BrandListDTO>
    let fetchConvenienceList: (_ serviceName: String) -> Observable<ConvenienceListDTO>
}

extension FacilityService {
    static let live = Self(
        fetchFoodMenu: { serviceName in
            return RouterManager<FacilityAPI>
                .init()
                .request(router: .fetchFoodMenu(serviceName: serviceName))
                .map { data in
                    do {
                        return try JSONDecoder().decode(FoodDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        },
        fetchOilCompany: { serviceName in
            return RouterManager<FacilityAPI>
                .init()
                .request(router: .fetchOilCompany(serviceName: serviceName))
                .map { data in
                    do {
                        return try JSONDecoder().decode(OilCompanyDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        },
        fetchBrandList: { serviceName in
            return RouterManager<FacilityAPI>
                .init()
                .request(router: .fetchBrandList(serviceName: serviceName))
                .map { data in
                    do {
                        return try JSONDecoder().decode(BrandListDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        },
        fetchConvenienceList: { serviceName in
            return RouterManager<FacilityAPI>
                .init()
                .request(router: .fetchConvenienceList(serviceName: serviceName))
                .map { data in
                    do {
                        return try JSONDecoder().decode(ConvenienceListDTO.self, from: data)
                    } catch {
                        throw RoadServiceError(code: .decodeFailed, underlying: error)
                    }
                }
                .asObservable()
        }
    )
}
