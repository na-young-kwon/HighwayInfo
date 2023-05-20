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
    private var selectedHighway: String
    
    struct Input {
        let selectedHighway: Observable<HighwayInfo?>
        let selectedServiceArea: Observable<ServiceArea>
    }
    
    struct Output {
        let highway: Driver<[HighwayInfo]>
        let result: Driver<([ServiceArea], [GasStation])>
    }
    
    init(coordinator: DefaultCardCoordinator, useCase: CardUseCase, highwayInfo: [HighwayInfo]) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.highwayInfo = highwayInfo
        self.selectedHighway = highwayInfo.first?.name.replacingOccurrences(of: "고속도로", with: "") ?? ""
    }
    
    func transform(input: Input) -> Output {
        let highway = Observable.just(highwayInfo).asDriver(onErrorJustReturn: [])
        let serviceArea = useCase.serviceArea.asObservable().share()
        let gasStation = useCase.gasStation.asObservable()
        let result = Observable.zip(serviceArea, gasStation).asDriver(onErrorJustReturn: ([], []))
        
        if let first = highwayInfo.first {
            useCase.fetchServiceArea(for: first.rawName)
            useCase.fetchGasStation(for: first.rawName)
        }
        input.selectedHighway
            .compactMap { $0.map { $0.rawName } }
            .subscribe(onNext: { [weak self] selectedRoute in
                self?.selectedHighway = ""
                self?.selectedHighway = selectedRoute
                self?.useCase.fetchServiceArea(for: selectedRoute)
                self?.useCase.fetchGasStation(for: selectedRoute)
            })
            .disposed(by: disposeBag)
        
        input.selectedServiceArea
            .subscribe(onNext: { [weak self] serviceArea in
                self?.coordinator.toFacilityView(with: serviceArea)
            })
            .disposed(by: disposeBag)
        
        serviceArea
            .subscribe(onNext: { [weak self] serviceArea in
                self?.serviceArea.removeAll()
                self?.serviceArea = serviceArea
            })
            .disposed(by: disposeBag)
        return Output(highway: highway, result: result)
    }
    
    func showServiceDetail() {
        coordinator.showServiceDetail(with: selectedHighway, serviceArea: serviceArea)
    }
    
    func removeCoordinator() {
        coordinator.removeCoordinator()
    }
    
    func popViewController() {
        coordinator.popViewController()
    }
}
