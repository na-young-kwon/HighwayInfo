//
//  MockLocationService.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

final class MockLocationService: NSObject, LocationService {
    private var authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    
    func start() {}
    
    func requestAuthorization() {}
    
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus> {
        return authorizationStatus.asObservable()
    }
    
    func currentLocation() -> Observable<[CLLocation]> {
        return Observable.just([CLLocation(latitude: 37, longitude: 127)])
    }
}
