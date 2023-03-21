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
    private let disposeBag = DisposeBag()
    
    var accidents = BehaviorSubject<[Accident]>(value: [])
    var images = BehaviorSubject<[String?]>(value: [])
    
    init(accidentRepository: AccidentRepository, cctvRepository: CCTVRepository) {
        self.accidentRepository = accidentRepository
        self.cctvRepository = cctvRepository
    }
    
    func fetchAccidents() {
        let allAccidents = accidentRepository.fetchAllAccidents()
        
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
            }}
            .subscribe { [weak self] totalAccident in
                self?.accidents.onNext(totalAccident)
            }
            .disposed(by: self.disposeBag)
    }
    
    func fetchImage(for accidents: [Accident]) {
        let coordinates = accidents.map { ($0.coord_x, $0.coord_y) }
        
        Observable<CctvDTO?>.zip(coordinates.map {  coord in
            cctvRepository.fetchPreviewBy(x: coord.0, y: coord.1)
        })
        .retry(3)
        .subscribe(onNext: { cctv in
            let urls = cctv.map { $0?.cctvurl ?? ""}
            self.images.onNext(urls)
        })
        .disposed(by: disposeBag)
    }
}
