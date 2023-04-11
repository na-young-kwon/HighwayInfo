//
//  SearchViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/06.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class SearchViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let useCase: SearchUseCase
    private let coordinator: DefaultSearchCoordinator
    
    struct Input {
        let searchKeyword: Observable<String>
        let itemSelected: Observable<LocationInfo?>
        let currentLocation: Observable<CLLocationCoordinate2D?>
    }
    
    struct Output {
        let searchResult: Observable<[LocationInfo]>
    }
    
    init(useCase: SearchUseCase, coordinator: DefaultSearchCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        Observable.combineLatest(input.currentLocation, input.searchKeyword)
            .subscribe(onNext: { coordinate, keyword in
                self.useCase.fetchResult(for: keyword, coordinate: coordinate)
            })
            .disposed(by: disposeBag)
        
        input.itemSelected
            .compactMap { $0 }
            .subscribe(onNext: { locationInfo in
                self.coordinator.toResultView(with: locationInfo)
            })
            .disposed(by: disposeBag)
            
        return Output(searchResult: useCase.searchResult.asObservable())
    }
}
