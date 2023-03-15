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
    var cctvPreviews = BehaviorSubject<String>(value: "여기에 어떤 값을 넣어둘까? placeholder같은거")
    
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
    
    // 이미지는 한개, cctv영상은 여러개일수있음
    func fetchCctvImage(for accident: Accident) -> String {
        accident.coord_x
        accident.coord_y
        return "image_url"
    }
    
    // 교통사고
    func fetchAccidents() {
        let allAccidents = repository.fetchAllAccidents()
            .map { $0.filter { $0.inciDesc.starts(with: self.accidentString) } }
            .share()

        // 이미지 가져오기
//        allAccidents.subscribe(onNext: {_ in
//            fetchCctvImage(for: <#T##Accident#>)
//        })
        
        allAccidents
            .map { $0.map { Accident(
                startTime: $0.startDate,
                estimatedEndTime: $0.estEndDate,
                place: $0.inciPlace1,
                direction: $0.inciPlace2,
                restrictType: $0.restrictType,
                description: $0.inciDesc,
                coord_x: Double($0.coord_x) ?? 0,
                coord_y: Double($0.coord_y) ?? 0)
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
                description: $0.inciDesc,
                coord_x: Double($0.coord_x) ?? 0,
                coord_y: Double($0.coord_y) ?? 0)
               }
            }
            .subscribe { [weak self] totalAccidentDTO in
                self?.accidents.onNext(totalAccidentDTO)
            }
            .disposed(by: self.disposeBag)
    }
}
