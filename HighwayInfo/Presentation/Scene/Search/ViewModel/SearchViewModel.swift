//
//  SearchViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/06.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchKeyword: Observable<String>
    }
    
    struct Output {
//        let searchResult
    }
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
