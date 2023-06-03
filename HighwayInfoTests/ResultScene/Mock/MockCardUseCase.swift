//
//  MockCardUseCase.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import Foundation
import RxSwift

final class MockCardUseCase: CardUseCase {
    var serviceArea = PublishSubject<[ServiceArea]>()
    var gasStation = PublishSubject<[GasStation]>()
    
    func fetchService(for highway: HighwayInfo) {
        let service = ServiceArea(id: "test_id",
                                  name: "기흥(부산)휴게소",
                                  serviceAreaCode: "A00003",
                                  convenience: "수유실|샤워실|세탁실",
                                  direction: "부산",
                                  address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                                  telNo: "031-286-5001")
        
        let gas = GasStation(uuid: "test_gas_uuid",
                             name: "화성(서울)주유소",
                             dieselPrice: "1,340원",
                             gasolinePrice: "1,520원",
                             lpgPrice: "X",
                             telNo: "055-312-2862",
                             oilCompany: "SK")
        
        serviceArea.onNext([service])
        gasStation.onNext([gas])
    }
}
