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
    private let coordinator: FacilityCoordinator?
    private let useCase: FacilityUseCase
    private let serviceArea: ServiceArea
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let selectedFacility: Observable<Facility>
    }
    
    struct Output {
        let serviceArea: ServiceArea
        let foodMenuList: Driver<[FoodMenu]>
        let convenienceList: Driver<[ConvenienceList]>
        let brandList: Driver<[Brand]>
        let gasStation: Observable<GasStation>
    }
    
    init(coordinator: FacilityCoordinator, useCase: FacilityUseCase, serviceArea: ServiceArea) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.serviceArea = serviceArea
    }
    
    func transform(input: Input) -> Output {
        let foodMenu = useCase.foodMenuList.asDriver(onErrorJustReturn: [])
        let convenienceList = useCase.convenienceList.asDriver(onErrorJustReturn: [])
        let brandList = useCase.brandList.asDriver(onErrorJustReturn: [])
        let gasStation = useCase.gasStation.asObservable()
        let serviceName = serviceArea.name
        
        input.viewWillAppear
            .subscribe(onNext: { _ in
                self.useCase.fetchFoodMenu(for: self.serviceArea)
                self.useCase.fetchGasStation(for: serviceName)
            })
            .disposed(by: disposeBag)
        
        input.selectedFacility
            .subscribe(onNext: { facility in
                switch facility {
                case .foodMenu:
                    self.useCase.fetchFoodMenu(for: self.serviceArea)
                case .convenienceList:
                    self.useCase.fetchConvenienceList(for: self.serviceArea)
                case .brandList:
                    self.useCase.fetchBrandList(for: self.serviceArea)
                }
            })
            .disposed(by: disposeBag)
        
        return  Output(serviceArea: serviceArea,
                       foodMenuList: foodMenu,
                       convenienceList: convenienceList,
                       brandList: brandList,
                       gasStation: gasStation)
    }
    
    func removeFromSuperview() {
        coordinator?.removeCoordinator()
    }
}
