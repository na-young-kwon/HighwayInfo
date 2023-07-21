//
//  DefaultUserRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/24.
//

import Foundation
import RxSwift

final class DefaultUserRepository: UserRepository {
    private let userDefault = UserDefaults.standard
    private let locationInfoKey = "locationInfo"
    
    func saveHistory(with locationInfo: LocationInfo) {
        guard let data = userDefault.data(forKey: locationInfoKey) else {
            saveFirstLocation(locationInfo)
            return
        }
        guard var info = try? JSONDecoder().decode([LocationInfo].self, from: data) else {
            return
        }
        if info.contains(locationInfo) == false {
            info.reverse()
            info.append(locationInfo)
            guard let encoded = try? JSONEncoder().encode(info.reversed()) else {
                return
            }
            userDefault.set(encoded, forKey: locationInfoKey)
        }
    }
    
    func fetchSearchHistory() -> Observable<[LocationInfo]> {
        guard let data = userDefault.data(forKey: locationInfoKey),
              let decoded = try? JSONDecoder().decode([LocationInfo].self, from: data) else {
            return Observable.of([])
        }
        return Observable.of(decoded)
    }
    
    func deleteAll() {
        userDefault.removeObject(forKey: "locationInfo")
    }
    
    private func saveFirstLocation(_ locationInfo: LocationInfo) {
        guard let encoded = try? JSONEncoder().encode([locationInfo]) else {
            return
        }
        userDefault.set(encoded, forKey: locationInfoKey)
    }
}
