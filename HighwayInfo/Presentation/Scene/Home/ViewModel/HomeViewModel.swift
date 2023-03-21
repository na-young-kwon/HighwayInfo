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
        let accidents = BehaviorRelay<[(AccidentViewModel, String?)]>(value: [])
    }
    
    private weak var coordinator: DefaultHomeCoordinator!
    private let useCase: DefaultAccidentUseCase
    private let accidentViewModels = BehaviorSubject<[(AccidentViewModel, String?)]>(value: [])
    
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
                self.useCase.fetchImage(for: totalAccident)
                self.makeViewModel(accidents: totalAccident)
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
        
        input.imageViewTapped
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { coordinate in
                print(coordinate)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func makeViewModel(accidents: [Accident]) {
        useCase.images
            .subscribe(onNext: { urls in
                let viewModels = accidents.map { AccidentViewModel(accident: $0) }
                let zipped = Array(zip(viewModels, urls))
                self.accidentViewModels.onNext(zipped)
            })
            .disposed(by: disposeBag)
    }
}
