//
//  DefaultRoadUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

enum LocationAuthorizationStatus {
    case allowed, notAllowed, notDetermined
}

final class DefaultRoadUseCase: RoadUseCase {
    var currentLocation = PublishSubject<CLLocationCoordinate2D>()
    var authorizationStatus = BehaviorSubject<LocationAuthorizationStatus?>(value: nil)
    private let locationService: LocationService
    private let disposeBag = DisposeBag()
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func checkAuthorization() {
        locationService.observeUpdatedAuthorization()
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.authorizationStatus.onNext(.allowed)
                    self?.locationService.start()
                case .notDetermined:
                    self?.authorizationStatus.onNext(.notDetermined)
                    self?.locationService.requestAuthorization()
                case .denied, .restricted:
                    self?.authorizationStatus.onNext(.notAllowed)
                @unknown default:
                    self?.authorizationStatus.onNext(nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observeLocation() {
        return locationService.currentLocation()
            .compactMap { $0.last }
            .subscribe(onNext: { [weak self] location in
                self?.currentLocation.onNext(location.coordinate)
            })
            .disposed(by: disposeBag)
    }
}
