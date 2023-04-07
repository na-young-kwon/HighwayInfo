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
    private let useCase: DefaultRoadUseCase
    
    struct Input {
        let searchKeyword: Observable<String>
    }
    
    struct Output {
        let searchResult: Observable<[String]>
    }
    
    init(useCase: DefaultRoadUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.searchKeyword
            .subscribe(onNext: { keyword in
                self.useCase.fetchResult(for: keyword)
            })
            .disposed(by: disposeBag)

        return Output(searchResult:  useCase.searchResult.asObservable())
    }
}
