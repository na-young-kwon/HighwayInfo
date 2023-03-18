//
//  DefaultAccidentUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation
import RxSwift

final class DefaultAccidentUseCase: AccidentUseCase {
    private let accidentRepository: AccidentRepository
    private let cctvRepository: CCTVRepository
    private let accidentString = "[차량사고]"
    private let disposeBag = DisposeBag()
    
    var accidents = BehaviorSubject<[Accident]>(value: [])
    var accidentsWithImage = BehaviorSubject<[AccidentViewModel]>(value: [])
    
    init(accidentRepository: AccidentRepository, cctvRepository: CCTVRepository) {
        self.accidentRepository = accidentRepository
        self.cctvRepository = cctvRepository
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
    func fetchCctvImage() {
        var accidentList: [AccidentViewModel] = []
//        let cctvUrl = cctvRepository.fetchPreviewBy(x: accident.coord_x,
//                                                    y: accident.coord_y)
//            .map { $0.cctvurl }
//
        accidents.asObservable()
            .subscribe(onNext: { accidents in
                Observable.zip( accidents.map { accident in
                    self.cctvRepository.fetchPreviewBy(x: accident.coord_x,
                                                                y: accident.coord_y)
                    .map { $0.response.data?.cctvURL ?? "" }
                        .map({ image in
                            accidentList.append(AccidentViewModel(accident: accident, cctvImage: image))
                        })
                })
                .subscribe(onNext: { [weak self] _ in
                    self?.accidentsWithImage.onNext(accidentList)
                })
                .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
       
    }
    
    // 교통사고
    func fetchAccidents() {
        let allAccidents = accidentRepository.fetchAllAccidents()
            .map { $0.filter { $0.inciDesc.starts(with: self.accidentString) } }
            .share()
        
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
        accidentRepository.fetchAllAccidents()
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
