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
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode([locationInfo])
            userDefault.set(encoded, forKey: locationInfoKey)
        } catch {
            print(error)
        }
    }
    
    func fetchSearchHistory() -> Observable<[LocationInfo]?> {
        var info: [LocationInfo] = []
        if let data = userDefault.data(forKey: locationInfoKey) {
            do {
                let decoder = JSONDecoder()
                info = try decoder.decode([LocationInfo].self, from: data)
            } catch {
                print(error)
            }
        }
        return Observable.of(info)
    }
}
