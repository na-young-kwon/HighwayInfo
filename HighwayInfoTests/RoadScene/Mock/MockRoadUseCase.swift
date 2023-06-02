//
//  MockRoadUseCase.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import Foundation
import RxSwift
import CoreLocation

final class MockRoadUseCase: RoadUseCase {
    var currentLocation = PublishSubject<CLLocationCoordinate2D>()
    var authorizationStatus = BehaviorSubject<LocationAuthorizationStatus?>(value: .notDetermined)
    private let locationService = MockLocationService()
    private let disposeBag = DisposeBag()
    
    func checkAuthorization() {
        locationService.observeUpdatedAuthorization()
            .subscribe(onNext: { status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    self.authorizationStatus.onNext(.allowed)
                    self.locationService.start()
                case .notDetermined:
                    self.authorizationStatus.onNext(.notDetermined)
                    self.locationService.requestAuthorization()
                case .denied, .restricted:
                    self.authorizationStatus.onNext(.notAllowed)
                @unknown default:
                    self.authorizationStatus.onNext(nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observeLocation() {
        currentLocation.onNext(CLLocationCoordinate2D(latitude: 37, longitude: 127))
    }
}
