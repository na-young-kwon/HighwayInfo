//
//  UserRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/24.
//

import Foundation
import RxSwift

protocol UserRepository {
    func saveHistory(with locationInfo: LocationInfo)
    func fetchSearchHistory() -> Observable<[LocationInfo]>
    func deleteAll()
}
