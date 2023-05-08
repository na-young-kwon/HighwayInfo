//
//  FacilityViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa

final class FacilityViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let coordinator: DefaultFacilityCoordinator
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
    }
    
    init(coordinator: DefaultFacilityCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()

        return output
    }
    
    func removeFromSuperview() {
        coordinator.removeCoordinator()
    }
}
