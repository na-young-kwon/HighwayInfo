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
            .map { $0.map { AccidentViewModel(accident: $0) }}
            .subscribe(onNext: { totalAccident in
                output.accidents.accept(totalAccident)
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
            .map { self.filteredAccidents(for: input.selectedRoad.value) }
            .bind(onNext: { accidents in
                output.accidents.accept(accidents)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func filteredAccidents(for road: Road) -> [AccidentViewModel] {
        useCase.fetchAccidents(for: road)
        guard let accidents = try? useCase.accidents.value() else {
            return []
        }
        let accidentViewModel = accidents.map { AccidentViewModel(accident: $0) }
        return accidentViewModel
    }
}
