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
        let viewWillAppear: Observable<Void>
        let searchKeyword: Observable<String>
        let itemSelected: Observable<LocationInfo?>
        let currentLocation: Observable<CLLocationCoordinate2D?>
    }
    
    struct Output {
        let searchResult: Observable<[LocationInfo]>
        let searchHistory: Observable<[LocationInfo]>
    }
    
    init(useCase: SearchUseCase, coordinator: DefaultSearchCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let currentCoordinate = input.currentLocation.compactMap { $0 }.share()
        let searchKeyword = input.searchKeyword.compactMap { $0 }
        let selectedLocationInfo = input.itemSelected.compactMap { $0 }.share()
        
        let output = Output(searchResult: useCase.searchResult.asObservable(),
                            searchHistory: useCase.searchHistory.asObservable())
        input.viewWillAppear
            .subscribe(onNext: { _ in
                self.useCase.fetchSearchHistory()
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(currentCoordinate, searchKeyword)
            .subscribe(onNext: { coordinate, keyword in
                self.useCase.fetchResult(for: keyword, coordinate: coordinate)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(currentCoordinate, selectedLocationInfo)
            .subscribe(onNext: { startPoint, selectedLocationInfo in
                let endPoint = CLLocationCoordinate2D(latitude: Double(selectedLocationInfo.coordy) ?? 0,
                                                      longitude: Double(selectedLocationInfo.coordx) ?? 0)
                let markerPoint = (startPoint, endPoint)
                self.useCase.searchRoute(for: markerPoint, endPointName: selectedLocationInfo.name)
            })
            .disposed(by: disposeBag)

        selectedLocationInfo
            .subscribe(onNext: { location in
                self.useCase.saveSearchTerm(with: location)
        })
        .disposed(by: disposeBag)
        
        useCase.route
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { route in
                // 왜 두번 들어오지
                self.coordinator.toResultView(with: route)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func deleteHistory() {
        useCase.deleteSearchHistory()
    }
}
