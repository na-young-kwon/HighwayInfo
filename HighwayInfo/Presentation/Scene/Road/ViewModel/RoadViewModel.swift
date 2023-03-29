//
//  RoadViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa

final class RoadViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private var coordinator: DefaultRoadCoordinator
    private let routes = RouteList.allCases
    
    struct Input {
        let selectedRoute: Driver<IndexPath>
    }
    
    struct Output {
        let routes: Observable<[Route]>
    }
    
    init(coordinator: DefaultRoadCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.selectedRoute.asObservable()
            .subscribe(onNext: { indexPath in
                let route = self.routes[indexPath.row]
                self.coordinator.toRoadDetail(with: route)
            })
            .disposed(by: disposeBag)
  
        return Output(routes: Observable.just(routes))
    }
}
