//
//  RoadUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import Foundation
import CoreLocation

protocol RoadUseCase {
    func fetchResult(for keyword: String, coordinate: CLLocationCoordinate2D?)
}
