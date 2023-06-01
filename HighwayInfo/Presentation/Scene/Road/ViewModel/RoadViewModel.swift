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
    private let coordinator: RoadCoordinator?
    private var currentLocation: CLLocationCoordinate2D?
    let useCase: RoadUseCase
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let showAuthorizationAlert = BehaviorRelay<Bool>(value: false)
        let currentLocation: Observable<CLLocationCoordinate2D>
    }
    
    init(coordinator: RoadCoordinator, useCase: RoadUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let output = Output(currentLocation: useCase.currentLocation.asObservable())
        
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
            .subscribe(onNext: { location in
                self.currentLocation = location
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func showSearchView() {
        guard let currentLocation = currentLocation else { return }
        coordinator?.showSearchView(with: currentLocation)
    }
}
