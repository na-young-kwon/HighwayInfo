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
        let viewWillAppear: Observable<Void>
        let upButtonTap: Observable<Void>
        let reverseButtonTap: Observable<Void>
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
        
        input.viewWillAppear
            .subscribe(onNext: { _ in
                self.useCase.fetchLocationInfo()
            })
            .disposed(by: disposeBag)
        
        input.upButtonTap
            .subscribe(onNext: { _ in
                self.useCase.isReverse.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.reverseButtonTap
            .subscribe(onNext: { _ in
                self.useCase.isReverse.accept(true)
            })
            .disposed(by: disposeBag)
        
        return Output(route: useCase.route, roads: roads)
    }
}
