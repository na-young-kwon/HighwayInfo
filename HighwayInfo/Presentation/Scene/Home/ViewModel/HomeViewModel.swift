//
//  HomeViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/09.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Observable<Void>
        let refreshButtonTapped: Observable<Void>
        let imageViewTapped: Observable<(Double, Double)>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let accidents = BehaviorRelay<[AccidentViewModel]>(value: [])
        let videoURL = BehaviorSubject<String?>(value: nil)
    }
    
    private weak var coordinator: DefaultHomeCoordinator!
    private let useCase: DefaultAccidentUseCase
    private let accidentViewModels = BehaviorSubject<[AccidentViewModel]>(value: [])
    
    init(useCase: DefaultAccidentUseCase, coordinator: DefaultHomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let fetching = activityIndicator.asDriver()
        
        let output = Output(fetching: fetching)
        
        useCase.accidents
            .subscribe(onNext: { totalAccident in
                output.accidents.accept(totalAccident)
            })
            .disposed(by: disposeBag)
        
        accidentViewModels
            .subscribe(onNext: { models in
                output.accidents.accept(models)
            })
            .disposed(by: disposeBag)
        
        input.trigger
            .subscribe { _ in
                self.useCase.fetchAccidents()
            }
            .disposed(by: disposeBag)
        
        input.refreshButtonTapped
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.useCase.fetchAccidents()
            })
            .disposed(by: disposeBag)
        
//        input.imageViewTapped
//            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { coordinate in
//                self.useCase.fetchVideo(for: coordinate)
//                    .subscribe(onNext: { cctv in
//                        output.videoURL.onNext(cctv?.cctvurl)
//                    }).disposed(by: self.disposeBag)
//            })
//            .disposed(by: disposeBag)
        
        return output
    }
}
