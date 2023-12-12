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
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
    }
    
    init(useCase: RoadUseCase, coordinator: RoadCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.checkAuthorization()
                self?.useCase.observeLocation()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    func showSearchView() {
        guard let currentLocation = currentLocation else { return }
        coordinator?.showSearchView(with: currentLocation)
    }
}
