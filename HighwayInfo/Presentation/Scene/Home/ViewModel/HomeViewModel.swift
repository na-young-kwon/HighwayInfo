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
        let selectedRoad: BehaviorRelay<Road>
        let refreshButtonTapped: Observable<Void>
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
                self.useCase.fetchAccidents(for: .accident)
            }
            .disposed(by: disposeBag)
        
        input.selectedRoad
            .subscribe(onNext: { [weak self] road in
                self?.useCase.fetchAccidents(for: road)
            })
            .disposed(by: disposeBag)
        
        input.refreshButtonTapped
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.useCase.fetchAccidents(for: input.selectedRoad.value)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func makeViewModel(accidents: [Accident]) {
        let index = accidents.count
        useCase.fetchImage(for: accidents)
        
        for i in 0..<index {
            useCase.image
                .subscribe(onNext: { urls in
                    if urls.count > 0 {
                        let viewModel = (AccidentViewModel(accident: accidents[i]), urls[i])
                        self.accidentViewModels.onNext([viewModel])
                    } else {
                        let viewModel = (AccidentViewModel(accident: accidents[i]), "")
                        self.accidentViewModels.onNext([viewModel])
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
