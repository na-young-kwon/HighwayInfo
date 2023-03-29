//
//  RoadDetailViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift

final class RoadDetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    var useCase: DefaultRoadUseCase
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
    }
        
    init(useCase: DefaultRoadUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.trigger
            .subscribe(onNext: { _ in
                self.useCase.fetchLocationInfo()
            })
            .disposed(by: disposeBag)
        
        useCase.roads
            .subscribe(onNext: { roads in
                print(roads)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
