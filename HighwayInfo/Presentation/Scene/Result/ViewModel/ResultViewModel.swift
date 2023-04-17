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
    private let route: Route
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let markerPoint: Observable<(CLLocationCoordinate2D, CLLocationCoordinate2D)>
        let startPointName: Driver<String>
        let endPointName: Driver<String>
        let path: Observable<[CLLocationCoordinate2D]>
        let highwayInfo: Observable<[HighwayInfo]>
    }
    
    init(coordinator: DefaultResultCoordinator, route: Route, useCase: ResultUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.route = route
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        return Output(markerPoint: Observable.of(route.markerPoint),
                      startPointName: Observable.of(route.startPointName).asDriver(onErrorJustReturn: ""),
                      endPointName: Observable.of(route.endPointName).asDriver(onErrorJustReturn: ""),
                      path: Observable.of(route.path),
                      highwayInfo: Observable.of(route.highwayInfo))
    }
    
    func removeCoordinator() {
        coordinator.removeCoordinator()
    }
}
