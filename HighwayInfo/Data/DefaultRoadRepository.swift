//
//  DefaultRoadRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift

final class DefaultRoadRepository: RoadRepository {
    private let service: RoadService
    
    init(service: RoadService) {
        self.service = service
    }
}
