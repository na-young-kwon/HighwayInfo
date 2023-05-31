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
    private let gasStationCache = NSCache<NSString, CacheValue<[GasStation]>>()
    private let convenienceListCache = NSCache<NSString, CacheValue<[ConvenienceList]>>()
    private let foodMenuCache = NSCache<NSString, CacheValue<[FoodMenu]>>()
    private let brandCache = NSCache<NSString, CacheValue<[Brand]>>()
    
    func saveServiceArea(data: [ServiceArea], for name: String) {
        let key = NSString(string: name)
        serviceAreaCache.setObject(CacheValue(data), forKey: key)
    }
    
    func saveGasStation(data: [GasStation], for name: String) {
        let key = NSString(string: name)
        gasStationCache.setObject(CacheValue(data), forKey: key)
    }
    
    func saveConvenienceList(data: [ConvenienceList], for uuid: UUID) {
        let key = NSString(string: uuid.uuidString)
        convenienceListCache.setObject(CacheValue(data), forKey: key)
    }
    
    func saveFoodMenu(data: [FoodMenu], for uuid: UUID) {
        let key = NSString(string: uuid.uuidString)
        foodMenuCache.setObject(CacheValue(data), forKey: key)
    }
    
    func saveBrand(data: [Brand], for uuid: UUID) {
        let key = NSString(string: uuid.uuidString)
        brandCache.setObject(CacheValue(data), forKey: key)
    }
    
    func fetchServiceArea(for name: String) -> [ServiceArea]? {
        let key = NSString(string: name)
        guard let cache = serviceAreaCache.object(forKey: key) else {
            return nil
        }
        return cache.value
    }
    
    func fetchGasStation(for name: String) -> [GasStation]? {
        let key = NSString(string: name)
        guard let cache = gasStationCache.object(forKey: key) else {
            return nil
        }
        return cache.value
    }
    
    func fetchConvenienceList(for uuid: UUID) -> [ConvenienceList]? {
        let key = NSString(string: uuid.uuidString)
        guard let cache = convenienceListCache.object(forKey: key) else {
            return nil
        }
        return cache.value
    }
    
    func fetchFoodMenu(for uuid: UUID) -> [FoodMenu]? {
        let key = NSString(string: uuid.uuidString)
        guard let cache = foodMenuCache.object(forKey: key) else {
            return nil
        }
        return cache.value
    }
    
    func fetchBrand(for uuid: UUID) -> [Brand]? {
        let key = NSString(string: uuid.uuidString)
        guard let cache = brandCache.object(forKey: key) else {
            return nil
        }
        return cache.value
    }
}
