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
        accidentRepository.fetchAllAccidents()
            .map { $0.map { $0.toDomain } }
            .subscribe(onNext: { accidents in
                self.fetchImage(for: accidents)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func fetchImage(for accidents: [Accident]) {
        let coordinates = accidents.map { ($0.coord_x, $0.coord_y) }
        
        let previewsObservable = Observable<CctvDTO?>.zip(coordinates.map { coord in
            cctvRepository.fetchPreviewBy(x: coord.0, y: coord.1)
        }).map { $0.map { $0?.cctvurl } }
        
        let videoObservable = Observable<CctvDTO?>.zip(coordinates.map { coord in
            cctvRepository.fetchVideo(x: coord.0, y: coord.1)
        }).map { $0.map { $0?.cctvurl } }
        
        Observable.zip(previewsObservable, videoObservable)
            .retry(3)
            .subscribe(onNext: { (previews, videos) in
                let viewModels = self.makeViewModel(accidents: accidents, previews: previews, videos: videos)
                self.accidents.onNext(viewModels)
            })
            .disposed(by: disposeBag)
    }
    
    private func makeViewModel(accidents: [Accident], previews: [String?], videos: [String?]) -> [AccidentViewModel] {
        let accident = Observable.from(accidents)
        let url = Observable.from(previews)
        let video = Observable.from(videos)
        var viewModels: [AccidentViewModel] = []
        
        Observable.zip(accident, url, video)
            .subscribe(onNext: { (accident, url, video) in
                viewModels.append(AccidentViewModel(id: UUID().uuidString, accident: accident, preview: url, video: video))
            })
            .disposed(by: disposeBag)
        return viewModels
    }
}
