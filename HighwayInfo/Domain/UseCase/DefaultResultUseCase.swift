//
//  DefaultResultUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

final class DefaultResultUseCase: ResultUseCase {
    var currentLocation = PublishSubject<CLLocation>()
    private let locationService: LocationService
    private let disposeBag = DisposeBag()
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func observeLocation() {
        return locationService.currentLocation()
            .compactMap { $0.last }
            .subscribe(onNext: { [weak self] location in
                self?.currentLocation.onNext(location)
            })
            .disposed(by: disposeBag)
    }
}
