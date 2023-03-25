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
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let accidents = BehaviorRelay<[AccidentViewModel]>(value: [])
    }
    
    private weak var coordinator: DefaultHomeCoordinator!
    private let useCase: DefaultAccidentUseCase
    
    init(useCase: DefaultAccidentUseCase, coordinator: DefaultHomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let fetching = activityIndicator.asDriver()
        
        let output = Output(fetching: fetching)
        
        useCase.accidents
            .trackActivity(activityIndicator)
            .subscribe(onNext: { totalAccident in
                output.accidents.accept(totalAccident)
            })
            .disposed(by: disposeBag)
        
        input.trigger
            .trackActivity(activityIndicator)
            .subscribe { _ in
                self.useCase.fetchAccidents()
            }
            .disposed(by: disposeBag)
        
        input.refreshButtonTapped
            .trackActivity(activityIndicator)
            .throttle(.seconds(5), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.useCase.fetchAccidents()
            })
            .disposed(by: disposeBag)
        return output
    }
}
