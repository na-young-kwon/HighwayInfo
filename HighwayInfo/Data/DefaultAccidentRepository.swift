//
//  DefaultAccidentRepository.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/08.
//

import Foundation
import RxSwift

final class DefaultAccidentRepository: AccidentRepository {
    private let service: RoadService
    
    init(service: RoadService) {
        self.service = service
    }
    
    func fetchAllAccidents() -> Observable<[AccidentDTO]> {
        service.fetchAllAccidents()
    }
}
