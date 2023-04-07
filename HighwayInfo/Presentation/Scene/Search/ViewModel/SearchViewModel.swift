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
    private let coordinator: DefaultSearchCoordinator
    
    struct Input {
        let searchKeyword: Observable<String>
        let modelSelected: Observable<LocationInfo>
    }
    
    struct Output {
        let searchResult: Observable<[LocationInfo]>
    }
    
    init(useCase: DefaultRoadUseCase, coordinator: DefaultSearchCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.searchKeyword
            .subscribe(onNext: { keyword in
                self.useCase.fetchResult(for: keyword)
            })
            .disposed(by: disposeBag)
        
        input.modelSelected
            .do { locationInfo in
                self.coordinator.toResultView(with: locationInfo)
            }
            
        return Output(searchResult:  useCase.searchResult.asObservable())
    }
}
