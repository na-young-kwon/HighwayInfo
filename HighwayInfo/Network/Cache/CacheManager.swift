//
//  CacheService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/30.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    private let serviceAreaCache = NSCache<NSString, CacheValue<[ServiceArea]>>()
    private let gasStationAreaCache = NSCache<NSString, CacheValue<[GasStation]>>()
    
    func saveServiceArea(data: [ServiceArea], for uuid: UUID) {
        let key = NSString(string: uuid.uuidString)
        serviceAreaCache.setObject(CacheValue(data), forKey: key)
    }
    
    func saveGasStation(data: [GasStation], for uuid: UUID) {
        let key = NSString(string: uuid.uuidString)
        gasStationAreaCache.setObject(CacheValue(data), forKey: key)
    }
    
    func fetchServiceArea(for uuid: UUID) -> [ServiceArea]? {
        let key = NSString(string: uuid.uuidString)
        if let cache = serviceAreaCache.object(forKey: key) {
            return cache.value
        } else {
            return nil
        }
    }
    
    func fetchGasStation(for uuid: UUID) -> [GasStation]? {
        let key = NSString(string: uuid.uuidString)
        if let cache = gasStationAreaCache.object(forKey: key) {
            return cache.value
        } else {
            return nil
        }
    }
}
