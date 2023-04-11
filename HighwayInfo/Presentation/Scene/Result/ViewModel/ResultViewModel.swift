//
//  File.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class ResultViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private var coordinator: DefaultResultCoordinator
    
    struct Input {
    }
    
    struct Output {
    }
    
    init(coordinator: DefaultResultCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func removeCoordinator() {
        coordinator.removeCoordinator()
    }
}
