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
    private var coordinator: DefaultRoadCoordinator
    
    struct Input {
    }
    
    struct Output {
    }
    
    init(coordinator: DefaultRoadCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
