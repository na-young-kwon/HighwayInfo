//
//  RoadViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa

final class RoadViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
    }
    
    private weak var coordinator: DefaultHomeCoordinator!
    private let useCase: DefaultAccidentUseCase
    
    init(useCase: DefaultAccidentUseCase, coordinator: DefaultHomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
