//
//  CacheValue.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/30.
//

import Foundation

class CacheValue<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }
}
