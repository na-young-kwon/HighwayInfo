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
    
    var accidents = BehaviorSubject<[AccidentViewModel]>(value: [])
    
    init(accidentRepository: AccidentRepository, cctvRepository: CCTVRepository) {
        self.accidentRepository = accidentRepository
        self.cctvRepository = cctvRepository
    }
    
    func fetchAccidents() {
        let accidentDTOs = accidentRepository.fetchAllAccidents()
            .map { $0.map {
                Accident(
                    startTime: $0.startDate,
                    place: $0.inciPlace1,
                    direction: $0.inciPlace2,
                    restrictType: $0.restrictType,
                    description: $0.inciDesc,
                    coord_x: Double($0.coord_x) ?? 0,
                    coord_y: Double($0.coord_y) ?? 0)
            }}
        
        accidentDTOs
            .subscribe(onNext: { accidents in
                self.fetchImage(for: accidents)
            })
            .disposed(by: self.disposeBag)
    }

    func fetchImage(for accidents: [Accident]) {
        let coordinates = accidents.map { ($0.coord_x, $0.coord_y) }
        
        Observable<CctvDTO?>.zip(coordinates.map { coord in
            cctvRepository.fetchPreviewBy(x: coord.0, y: coord.1)
        })
        .map { $0.map { $0?.cctvurl } }
        .retry(3)
        .subscribe(onNext: { urls in
            let viewModels = self.makeViewModel(accidents: accidents, urls: urls)
            self.accidents.onNext(viewModels)
        })
        .disposed(by: disposeBag)
    }
    
    func makeViewModel(accidents: [Accident], urls: [String?]) -> [AccidentViewModel] {
        let accident: Observable<Accident> = Observable.from(accidents)
        let url: Observable<String?> = Observable.from(urls)
        var viewModels: [AccidentViewModel] = []
        
        Observable.zip(accident, url)
            .subscribe(onNext: { (accident, url) in
                viewModels.append(AccidentViewModel(accident: accident, preview: url))
            })
            .disposed(by: disposeBag)
        return viewModels
    }
}
