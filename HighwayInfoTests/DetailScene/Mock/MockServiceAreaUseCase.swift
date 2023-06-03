//
//  c.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/03.
//

import Foundation
import RxSwift

final class MockServiceAreaUseCase: ServiceAreaUseCase {
    func filterServiceArea(with: [ServiceArea], for: Convenience) -> [ServiceArea] {
        return [ServiceArea(id: "test_id",
                           name: "기흥(부산)휴게소",
                           serviceAreaCode: "A00003",
                           convenience: "수유실|샤워실|세탁실",
                           direction: "부산",
                           address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                           telNo: "031-286-5001")]
    }
}
