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
    private let useCase: ServiceAreaUseCase
    private let highwayName: String
    private let serviceArea: [ServiceArea]
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let selectedCategory: Observable<Convenience>
        let selectedServiceArea: Observable<ServiceArea>
    }
    
    struct Output {
        let highwayName: Driver<String>
        let serviceArea: Observable<[ServiceArea]>
    }
    
    init(coordinator: DefaultServiceAreaCoordinator, useCase: ServiceAreaUseCase, highwayName: String, serviceArea: [ServiceArea]) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.highwayName = highwayName + " 고속도로 휴게소"
        self.serviceArea = serviceArea
    }
    
    func transform(input: Input) -> Output {
        let highwayName = Driver.of(highwayName)
        let serviceArea = BehaviorSubject<[ServiceArea]>(value: serviceArea)
        let output = Output(highwayName: highwayName, serviceArea: serviceArea.asObservable())
        
        input.selectedCategory
            .subscribe(onNext: { category in
                let filteredArea = self.useCase.filterServiceArea(with: self.serviceArea, for: category)
                serviceArea.onNext(filteredArea)
            })
            .disposed(by: disposeBag)
        
        input.selectedServiceArea
            .subscribe(onNext: { serviceArea in
                self.coordinator.toFacilityView(with: serviceArea)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func removeFromSuperview() {
        coordinator.removeCoordinator()
    }
}
