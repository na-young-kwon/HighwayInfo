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
    private let accidentString = "[차량사고]"
    
    init(repository: AccidentRepository) {
        self.repository = repository
    }

    
    func fetchAccidents(for road: Road) -> Observable<[Accident]> {
        switch road {
        case .accident:
            return fetchAccidents()
        case .construction:
            return fetchConstructions()
        }
    }
    
    // 교통사고
    func fetchAccidents() -> RxSwift.Observable<[Accident]> {
        let accidentsDTO = repository.fetchAllAccidents()
        let filteredAccidentsDTO = accidentsDTO.map { $0.filter { $0.inciDesc.starts(with: self.accidentString) } }
        let accidents = filteredAccidentsDTO.map { $0.map { Accident(
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
    
    // 공사, 적재물낙하, 장애물, 도로폐쇄
    func fetchConstructions() -> RxSwift.Observable<[Accident]> {
        let accidentsDTO = repository.fetchAllAccidents()
        let constructionsDTO = accidentsDTO.map { $0.filter { !$0.inciDesc.starts(with: self.accidentString) } }
        let constructions = constructionsDTO.map { $0.map { Accident(
            startTime: $0.startDate,
            estimatedEndTime: $0.estEndDate,
            place: $0.inciPlace1,
            direction: $0.inciPlace2,
            restrictType: $0.restrictType,
            description: $0.inciDesc)
           }
        }
        return constructions
    }
}
