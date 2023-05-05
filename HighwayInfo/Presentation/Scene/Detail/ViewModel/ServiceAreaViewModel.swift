//
//  ServiceAreaViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/04.
//

import Foundation
import RxSwift
import RxCocoa

final class ServiceAreaViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let coordinator: DefaultServiceAreaCoordinator
    private let highwayName: String
    private let serviceArea: [ServiceArea]
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let highwayName: Driver<String>
        let serviceArea: Observable<[ServiceArea]>
    }
    
    init(coordinator: DefaultServiceAreaCoordinator, highwayName: String, serviceArea: [ServiceArea]) {
        self.coordinator = coordinator
        self.highwayName = highwayName + " 고속도로 휴게소"
        self.serviceArea = serviceArea
    }
    
    func transform(input: Input) -> Output {
        let highwayName = Driver.of(highwayName)
        let serviceArea = Observable.just(serviceArea)
        let output = Output(highwayName: highwayName, serviceArea: serviceArea)
        
        return output
    }
}
