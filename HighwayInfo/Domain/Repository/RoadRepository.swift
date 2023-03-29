//
//  RoadRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift

protocol RoadRepository {
    func fetchLocationInfo(for: Route) -> Observable<[RoadDTO]>
}