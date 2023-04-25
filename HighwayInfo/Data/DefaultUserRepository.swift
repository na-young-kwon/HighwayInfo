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
        if let data = userDefault.data(forKey: locationInfoKey) {
            do {
                var info: [LocationInfo] = []
                info = try JSONDecoder().decode([LocationInfo].self, from: data)
                info.reverse()
                info.append(locationInfo)
                info.reverse()
                let encoded = try JSONEncoder().encode(info)
                userDefault.set(encoded, forKey: locationInfoKey)
            } catch {
                print(error)
            }
        } else {
            // 처음저장할때 여기탈텐데
            print("처음저장할 때")
        }
    }
    
    func fetchSearchHistory() -> Observable<[LocationInfo]> {
        var info: [LocationInfo] = []
        guard let data = userDefault.data(forKey: locationInfoKey) else {
            return Observable.of([])
        }
        do {
            info = try JSONDecoder().decode([LocationInfo].self, from: data)
        } catch {
            print(error)
        }
        return Observable.of(info)
    }
}
