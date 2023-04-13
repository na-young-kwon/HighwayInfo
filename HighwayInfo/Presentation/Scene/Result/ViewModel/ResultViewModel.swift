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
        let path: Observable<[CLLocationCoordinate2D]>
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
               
            })
            .disposed(by: disposeBag)
        
        let endPoint = CLLocationCoordinate2D(latitude: Double(locationInfo.coordy) ?? 0,
                                              longitude: Double(locationInfo.coordx) ?? 0)
        let endPointName = Observable.of(locationInfo.name).asDriver(onErrorJustReturn: "")
        let markerPoint = Observable.of((currentLocation, endPoint)).share()
        let path = useCase.path.asObservable()
        
        markerPoint.subscribe(onNext: { point in
            self.useCase.searchRoute(for: point)
            self.useCase.highway(for: point)
        })
        .disposed(by: disposeBag)
        
        return Output(markerPoint: markerPoint, endPointName: endPointName, path: path)
    }
    
    func removeCoordinator() {
        coordinator.removeCoordinator()
    }
}
