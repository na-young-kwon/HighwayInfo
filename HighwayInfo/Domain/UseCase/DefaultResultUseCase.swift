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
    private let disposeBag = DisposeBag()
    var path = PublishSubject<[CLLocationCoordinate2D]>()
    
    init() {
    }
    
    func searchRoute() {
        let position = CLLocationCoordinate2D(latitude: 37.57084, longitude: 126.985302)
        var path = Array<CLLocationCoordinate2D>()
        path.append(CLLocationCoordinate2D(latitude: position.latitude - 0.001, longitude: position.longitude - 0.001))
        path.append(CLLocationCoordinate2D(latitude: position.latitude + 0.001, longitude: position.longitude - 0.0005))
        path.append(CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude))
        path.append(CLLocationCoordinate2D(latitude: position.latitude + 0.001, longitude: position.longitude + 0.0005))
        path.append(CLLocationCoordinate2D(latitude: position.latitude - 0.001, longitude: position.longitude + 0.001))
        self.path.onNext(path)
    }
}
