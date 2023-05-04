//
//  CardViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import Foundation
import RxSwift
import RxCocoa

final class CardViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let coordinator: DefaultCardCoordinator
    private let useCase: CardUseCase
    private let highwayInfo: [HighwayInfo]
    private var serviceArea: [ServiceArea] = []
    
    struct Input {
        let itemSelected: Observable<HighwayInfo?>
    }
    
    struct Output {
        let highway: Observable<[HighwayInfo]>
        let result: Observable<([ServiceArea], [GasStation])>
    }
    
    init(coordinator: DefaultCardCoordinator, useCase: CardUseCase, highwayInfo: [HighwayInfo]) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.highwayInfo = highwayInfo
    }
    
    func transform(input: Input) -> Output {
        let highway = Observable.just(highwayInfo)
        let serviceArea = useCase.serviceArea.asObservable().share()
        let gasStation = useCase.gasStation.asObservable()
        let result = Observable.zip(serviceArea, gasStation)
        
        if let first = highwayInfo.first {
            useCase.fetchServiceArea(for: first.rawName)
            useCase.fetchGasStation(for: first.rawName)
        }
        input.itemSelected
            .compactMap { $0.map { $0.rawName } }
            .subscribe(onNext: { selectedRoute in
                self.useCase.fetchServiceArea(for: selectedRoute)
                self.useCase.fetchGasStation(for: selectedRoute)
            })
            .disposed(by: disposeBag)
        
        serviceArea
            .subscribe(onNext: { serviceArea in
                self.serviceArea.removeAll()
                self.serviceArea = serviceArea
            })
            .disposed(by: disposeBag)
        return Output(highway: highway, result: result)
    }
    
    func showServiceDetail() {
        self.coordinator.showServiceDetail(with: serviceArea)
    }
    
    func showGasStationDetail() {
        coordinator.showGasStationDetail(with: "DD")
    }
}
