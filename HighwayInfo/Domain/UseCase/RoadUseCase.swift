//
//  RoadUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import Foundation
import RxSwift
import CoreLocation

protocol RoadUseCase {
    var currentLocation: PublishSubject<CLLocation> { get }
    var authorizationStatus: BehaviorSubject<LocationAuthorizationStatus?> { get }
    func checkAuthorization()
    func observeLocation()
}
