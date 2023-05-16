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
    private let route: Route
    let cardViewModel: CardViewModel
    
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
    
    init(coordinator: DefaultResultCoordinator, route: Route, cardViewModel: CardViewModel) {
        self.coordinator = coordinator
        self.route = route
        self.cardViewModel = cardViewModel
    }
    
    func transform(input: Input) -> Output {
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
