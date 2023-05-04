//
//  ServiceAreaViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/04.
//

import Foundation
import RxSwift

final class ServiceAreaViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let coordinator: DefaultServiceAreaCoordinator
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
    }
    
    init(coordinator: DefaultServiceAreaCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
