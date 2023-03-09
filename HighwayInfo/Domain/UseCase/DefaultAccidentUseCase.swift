//
//  DefaultAccidentUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation
import RxSwift

final class DefaultAccidentUseCase: AccidentUseCase {
    let repository: AccidentRepository
    
    init(repository: AccidentRepository) {
        self.repository = repository
    }

    func fetchAllAccidents() -> RxSwift.Observable<[Accident]> {
        let accidentsDTO = repository.fetchAllAccidents()
        let accidents = accidentsDTO.map { $0.map { Accident(
            startTime: $0.startDate,
            estimatedEndTime: $0.estEndDate,
            place: $0.inciPlace1,
            direction: $0.inciPlace2,
            restrictType: $0.restrictType,
            description: $0.inciDesc)
           }
        }
        return accidents
    }
}
