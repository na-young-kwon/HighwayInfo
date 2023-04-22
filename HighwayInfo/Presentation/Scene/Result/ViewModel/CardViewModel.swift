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
    }
    
    struct Output {
        let emptyHighway: Observable<Bool>
    }
    
    init(coordinator: DefaultCardCoordinator, useCase: CardUseCase, highwayInfo: [HighwayInfo]) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.highwayInfo = highwayInfo
    }
    
    func transform(input: Input) -> Output {
        let emptyHighway = Observable.just(highwayInfo.isEmpty)
        
        return Output(emptyHighway: emptyHighway)
    }
}
