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
    private let useCase: DefaultFacilityUseCase
    private let serviceArea: ServiceArea
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let serviceAreaName: String
        let foodMenuList: Observable<[FoodMenu]>
    }
    
    init(coordinator: DefaultFacilityCoordinator, useCase: DefaultFacilityUseCase, serviceArea: ServiceArea) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.serviceArea = serviceArea
    }
    
    func transform(input: Input) -> Output {
        let foodMenu = useCase.foodMenuList.asObservable()
        
        input.viewWillAppear
            .subscribe(onNext: { _ in
//                self.useCase.fetchGasPrice(for: self.serviceArea.name)
                self.useCase.fetchFoodMenu(for: self.serviceArea.name)
            })
            .disposed(by: disposeBag)
        
        return  Output(serviceAreaName: serviceArea.serviceName,
                       foodMenuList: foodMenu)
    }
    
    func removeFromSuperview() {
        coordinator.removeCoordinator()
    }
}
