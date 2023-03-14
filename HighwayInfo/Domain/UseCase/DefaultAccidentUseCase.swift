//
//  DefaultAccidentUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation
import RxSwift

final class DefaultAccidentUseCase: AccidentUseCase {
    private let repository: AccidentRepository
    private let accidentString = "[차량사고]"
    private let disposeBag = DisposeBag()
    
    var accidents = BehaviorSubject<[Accident]>(value: [])
    
    init(repository: AccidentRepository) {
        self.repository = repository
    }

    func fetchAccidents(for road: Road) {
        switch road {
        case .accident:
             fetchAccidents()
        case .construction:
             fetchConstructions()
        }
    }
    
    // 교통사고
    func fetchAccidents() {
        repository.fetchAllAccidents()
            .map { $0.filter { $0.inciDesc.starts(with: self.accidentString) } }
            .map { $0.map { Accident(
                startTime: $0.startDate,
                estimatedEndTime: $0.estEndDate,
                place: $0.inciPlace1,
                direction: $0.inciPlace2,
                restrictType: $0.restrictType,
                description: $0.inciDesc)
               }
            }
            .subscribe { [weak self] totalAccidentDTO in
                self?.accidents.onNext(totalAccidentDTO)
            }
            .disposed(by: self.disposeBag)
    }
    
    // 공사, 적재물낙하, 장애물, 도로폐쇄
    func fetchConstructions() {
        repository.fetchAllAccidents()
            .map { $0.filter { !$0.inciDesc.starts(with: self.accidentString) } }
            .map { $0.map { Accident(
                startTime: $0.startDate,
                estimatedEndTime: $0.estEndDate,
                place: $0.inciPlace1,
                direction: $0.inciPlace2,
                restrictType: $0.restrictType,
                description: $0.inciDesc)
               }
            }
            .subscribe { [weak self] totalAccidentDTO in
                self?.accidents.onNext(totalAccidentDTO)
            }
            .disposed(by: self.disposeBag)
    }
}
