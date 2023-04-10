//
//  RoadRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift
import CoreLocation

protocol RoadRepository {
    func fetchSearchResult(for: String, coordinate: CLLocationCoordinate2D) -> Observable<SearchResultDTO>
}
