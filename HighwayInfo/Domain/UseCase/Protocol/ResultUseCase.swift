//
//  ResultUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift
import CoreLocation

protocol ResultUseCase {
    var path: PublishSubject<[CLLocationCoordinate2D]> { get }
    var highwayName: PublishSubject<String?> { get }
    var highwayInfo: PublishSubject<[HighwayInfo]> { get }
    func searchRoute(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D))
    func highway(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D))
}
