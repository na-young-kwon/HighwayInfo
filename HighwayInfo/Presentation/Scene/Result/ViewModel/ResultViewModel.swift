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
    private let currentLocation: CLLocationCoordinate2D
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let markerPoint: Observable<(CLLocationCoordinate2D, CLLocationCoordinate2D)>
        let endPointName: Driver<String>
    }
    
    init(coordinator: DefaultResultCoordinator, locationInfo: LocationInfo, useCase: ResultUseCase, currentLocation: CLLocationCoordinate2D) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.locationInfo = locationInfo
        self.currentLocation = currentLocation
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe(onNext: { _ in
                self.useCase.observeLocation()
            })
            .disposed(by: disposeBag)
        
        let coordinate = CLLocationCoordinate2D(latitude: Double(locationInfo.coordy) ?? 0,
                                                longitude: Double(locationInfo.coordx) ?? 0)
        let endPointName = Observable.of(locationInfo.name).asDriver(onErrorJustReturn: "")
        let markerPoint = Observable.of((currentLocation, coordinate))
        return Output(markerPoint: markerPoint, endPointName: endPointName)
    }
    
    func removeCoordinator() {
        coordinator.removeCoordinator()
    }
}
