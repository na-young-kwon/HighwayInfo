//
//  LocationService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

final class LocationService: NSObject {
    static let shared = LocationService()
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        return manager
    }()
    private let disposeBag: DisposeBag = DisposeBag()
    private let authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus> {
        return self.authorizationStatus.asObservable()
    }
    
    func currentLocation() -> Observable<[CLLocation]> {
        return PublishRelay<[CLLocation]>.create { observer in
            self.rx.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
                .compactMap { $0.last as? [CLLocation] }
                .subscribe(onNext: { location in
                    observer.onNext(location)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus.accept(status)
    }
}
