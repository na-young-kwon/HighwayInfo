//
//  RoadDetailViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa

final class RoadDetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    var useCase: DefaultRoadUseCase
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let route: Route
        let roads: Driver<[RoadDetail]>
    }
        
    init(useCase: DefaultRoadUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let roads = useCase.roads.asDriverOnErrorJustComplete()
        
        input.trigger
            .subscribe(onNext: { _ in
                self.useCase.fetchLocationInfo()
            })
            .disposed(by: disposeBag)
        
        return Output(route: useCase.route, roads: roads)
    }
}
