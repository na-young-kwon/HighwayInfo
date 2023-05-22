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
    private let currentLocation: CLLocationCoordinate2D
    private weak var coordinator: DefaultSearchCoordinator?
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchKeyword: Observable<String>
        let itemSelected: Observable<LocationInfo?>
    }
    
    struct Output {
        let searchResult: Observable<[LocationInfo]>
        let searchHistory: Observable<[LocationInfo]>
    }
    
    init(useCase: SearchUseCase, coordinator: DefaultSearchCoordinator?, currentLocation: CLLocationCoordinate2D) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.currentLocation = currentLocation
    }
    
    func transform(input: Input) -> Output {
        let searchKeyword = input.searchKeyword.compactMap { $0 }
        let selectedLocationInfo = input.itemSelected.compactMap { $0 }.share()
        
        let output = Output(searchResult: useCase.searchResult.asObservable(),
                            searchHistory: useCase.searchHistory.asObservable())
        input.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.observeLocation()
                self?.useCase.fetchSearchHistory()
            })
            .disposed(by: disposeBag)
        
        searchKeyword
            .subscribe(onNext: { [weak self] keyword in
                guard let self = self else { return }
                self.useCase.fetchResult(for: keyword, coordinate: self.currentLocation)
            })
            .disposed(by: disposeBag)
        
        selectedLocationInfo
            .subscribe(onNext: { [weak self] selectedLocationInfo in
                guard let self = self else { return }
                let endPoint = CLLocationCoordinate2D(latitude: Double(selectedLocationInfo.coordy) ?? 0,
                                                      longitude: Double(selectedLocationInfo.coordx) ?? 0)
                let markerPoint = (self.currentLocation, endPoint)
                self.useCase.searchRoute(for: markerPoint, endPointName: selectedLocationInfo.name)
            })
            .disposed(by: disposeBag)

        selectedLocationInfo
            .subscribe(onNext: { [weak self] location in
                self?.useCase.saveSearchTerm(with: location)
        })
        .disposed(by: disposeBag)
        
        useCase.route
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] route in
                self?.coordinator?.toResultView(with: route)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func popViewController() {
        coordinator?.popViewController()
    }
    
    func deleteHistory() {
        useCase.deleteSearchHistory()
    }
    
    func removeCoordinator() {
        coordinator?.removeCoordinator()
    }
}
