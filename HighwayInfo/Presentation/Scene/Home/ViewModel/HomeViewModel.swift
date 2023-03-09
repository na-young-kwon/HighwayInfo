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
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let accidents: Driver<[AccidentViewModel]>
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
        
        let accidents = input.trigger.flatMapLatest {
            return self.useCase.fetchAllAccidents()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
                .map { $0.map{ AccidentViewModel(accident: $0)} }
        }
        return Output(fetching: fetching,
                      accidents: accidents)
    }
}
