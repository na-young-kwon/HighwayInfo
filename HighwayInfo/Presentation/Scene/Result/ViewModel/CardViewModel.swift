//
//  CardViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import Foundation
import RxSwift
import RxCocoa

final class CardViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let coordinator: DefaultCardCoordinator
    private let useCase: CardUseCase
    private let highwayInfo: [HighwayInfo]
    
    struct Input {
        let itemSelected: Observable<HighwayInfo?>
    }
    
    struct Output {
        let highway: Observable<[HighwayInfo]>
    }
    
    init(coordinator: DefaultCardCoordinator, useCase: CardUseCase, highwayInfo: [HighwayInfo]) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.highwayInfo = highwayInfo
    }
    
    func transform(input: Input) -> Output {
        let highway = Observable.just(highwayInfo)
        
        input.itemSelected
            .compactMap { $0.map { $0.rawName } }
            .subscribe(onNext: { selectedRoute in
                self.useCase.fetchServiceArea(for: selectedRoute)
                self.useCase.fetchGasStation(for: selectedRoute)
            })
            .disposed(by: disposeBag)
        
        return Output(highway: highway)
    }
}
