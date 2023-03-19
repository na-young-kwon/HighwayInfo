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
    var images = BehaviorSubject<[String?]>(value: [])
    
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
    func fetchCctvImage(for accidents: [Accident]) {
        let coordinates = accidents.map { ($0.coord_x, $0.coord_y) }
        
        Observable<CctvDTO>.zip(coordinates.map {  coord in
            cctvRepository.fetchPreviewBy(x: coord.0, y: coord.1)
        })
        .subscribe(onNext: { cctv in
            let imageURL = cctv.map { $0.response.data?.cctvURL }
            self.images.onNext(imageURL)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchViewModel() -> [AccidentViewModel] {
        let accidents = accidents.asObservable()
        let images = images.asObservable()
        
        var viewModels: [AccidentViewModel] = []
        
        Observable.zip(accidents, images)
            .enumerated()
            .subscribe(onNext: { (index, element) in
                if element.0.count > 0 {
                    let newElement = AccidentViewModel(accident: element.0[index], cctvImage: element.1[index])
                    viewModels.append(newElement)
                }
            }).disposed(by: disposeBag)
        return viewModels
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
            .subscribe { [weak self] totalAccident in
                self?.accidents.onNext(totalAccident)
                self?.fetchCctvImage(for: totalAccident)
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
            .subscribe { [weak self] totalAccident in
                self?.accidents.onNext(totalAccident)
                self?.fetchCctvImage(for: totalAccident)
            }
            .disposed(by: self.disposeBag)
    }
}
