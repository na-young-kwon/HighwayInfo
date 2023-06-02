//
//  LocationService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/06/02.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

protocol LocationService {
    func start()
    func requestAuthorization()
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus>
    func currentLocation() -> Observable<[CLLocation]>
}
