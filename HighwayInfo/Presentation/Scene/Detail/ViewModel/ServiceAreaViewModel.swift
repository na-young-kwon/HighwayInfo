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
    private let serviceArea: [ServiceArea]
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let serviceArea: Observable<[ServiceArea]>
    }
    
    init(coordinator: DefaultServiceAreaCoordinator, serviceArea: [ServiceArea]) {
        self.coordinator = coordinator
        self.serviceArea = serviceArea
    }
    
    func transform(input: Input) -> Output {
        let serviceArea = Observable.just(serviceArea)
        let output = Output(serviceArea: serviceArea)
        
        return output
    }
}
