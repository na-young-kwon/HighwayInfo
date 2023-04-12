//
//  File.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class ResultViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let coordinator: DefaultResultCoordinator
    private let useCase: ResultUseCase
    private let locationInfo: LocationInfo
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
//        let startPoint: Observable<String>
        let endPointName: Driver<String>
    }
    
    init(coordinator: DefaultResultCoordinator, locationInfo: LocationInfo, useCase: ResultUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.locationInfo = locationInfo
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe(onNext: { _ in
                self.useCase.observeLocation()
            })
            .disposed(by: disposeBag)
        
        let startPoint = useCase.currentLocation.map { $0.coordinate }
        let endPoint = Observable.of((locationInfo.coordx, locationInfo.coordy))
        
        let endPointName = Observable.of(locationInfo.name).asDriver(onErrorJustReturn: "")
        
        return Output(endPointName: endPointName)
    }
    
    func removeCoordinator() {
        coordinator.removeCoordinator()
    }
}
