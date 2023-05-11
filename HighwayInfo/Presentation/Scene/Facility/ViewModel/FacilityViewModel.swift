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
        let selectedFacility: Observable<Facility>
    }
    
    struct Output {
        let serviceAreaName: String
        let foodMenuList: Observable<[FoodMenu]>
        let convenienceList: Observable<[ConvenienceList]>
        let brandList: Observable<[Brand]>
    }
    
    init(coordinator: DefaultFacilityCoordinator, useCase: DefaultFacilityUseCase, serviceArea: ServiceArea) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.serviceArea = serviceArea
    }
    
    func transform(input: Input) -> Output {
        let foodMenu = useCase.foodMenuList.asObservable()
        let convenienceList = useCase.convenienceList.asObservable()
        let brandList = useCase.brandList.asObservable()
        let serviceName = serviceArea.name
        
        input.viewWillAppear
            .subscribe(onNext: { _ in
                self.useCase.fetchFoodMenu(for: serviceName)
            })
            .disposed(by: disposeBag)
        
        input.selectedFacility
            .subscribe(onNext: { facility in
                switch facility {
                case .foodMenu:
                    self.useCase.fetchFoodMenu(for: serviceName)
                case .convenienceList:
                    self.useCase.fetchConvenienceList(for: serviceName)
                case .brandList:
                    self.useCase.fetchBrandList(for: serviceName)
                }
            })
            .disposed(by: disposeBag)
        
        return  Output(serviceAreaName: serviceArea.serviceName,
                       foodMenuList: foodMenu,
                       convenienceList: convenienceList,
                       brandList: brandList)
    }
    
    func removeFromSuperview() {
        coordinator.removeCoordinator()
    }
}
