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
    
    let route: Route // 이걸 유즈케이스로 옮길지 
    
    struct Input {
    }
    
    struct Output {
    }
        
    init(route: Route) {
        self.route = route
    }
    
    func transform(input: Input) -> Output {

        
        return Output()
    }
}