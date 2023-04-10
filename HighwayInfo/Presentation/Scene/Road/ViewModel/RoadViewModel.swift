//
//  RoadViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class RoadViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private var coordinator: DefaultRoadCoordinator
    let useCase: RoadUseCase
    let searchViewModel: SearchViewModel
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let showAuthorizationAlert = BehaviorRelay<Bool>(value: false)
        let currentLocation = PublishRelay<CLLocationCoordinate2D>()
    }
    
    init(coordinator: DefaultRoadCoordinator, useCase: RoadUseCase) {
        self.coordinator = coordinator
        self.searchViewModel = coordinator.searchViewModel!
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.checkAuthorization()
                self?.useCase.observeLocation()
            })
            .disposed(by: disposeBag)
        
        useCase.authorizationStatus
            .map { $0 == .notAllowed }
            .bind(to: output.showAuthorizationAlert)
            .disposed(by: disposeBag)
      
        useCase.currentLocation
            .map { $0.coordinate }
            .bind(to: output.currentLocation)
            .disposed(by: disposeBag)
        
        return output
    }
}
