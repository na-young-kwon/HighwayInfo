//
//  DefaultAccidentRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation
import RxSwift

final class DefaultAccidentRepository: AccidentRepository {
    private let service: AccidentService
    
    init(service: AccidentService) {
        self.service = service
    }
    
    func fetchAllAccidents() -> Observable<[AccidentDTO]> {
        service.fetchAllAccidents()
    }
}
