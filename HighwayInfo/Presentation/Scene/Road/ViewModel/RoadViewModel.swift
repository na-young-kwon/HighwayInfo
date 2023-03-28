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
    
    struct Input {
        let selectedRoute: Observable<Route>
    }
    
    struct Output {
    }
    
    private weak var coordinator: DefaultRoadCoordinator!
    
    init(coordinator: DefaultRoadCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.selectedRoute
            .subscribe(onNext: { route in
                print("디테일로 이동")
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
