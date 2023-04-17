//
//  SearchUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import Foundation
import RxSwift
import CoreLocation

protocol SearchUseCase {
    var searchResult: PublishSubject<[LocationInfo]> { get }
    var route: PublishSubject<Route> { get }
    func fetchResult(for keyword: String, coordinate: CLLocationCoordinate2D?)
    func searchRoute(for point: (CLLocationCoordinate2D, CLLocationCoordinate2D), endPointName: String)
}
