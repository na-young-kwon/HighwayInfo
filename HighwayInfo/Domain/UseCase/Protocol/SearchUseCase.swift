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
    func fetchResult(for keyword: String, coordinate: CLLocationCoordinate2D?)
}
