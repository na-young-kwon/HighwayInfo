//
//  ServiceArea.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/02.
//

import Foundation

struct ServiceArea {
    let id: String
    let name: String
    let serviceAreaCode: String
    let convenience: String
    let direction: String
    let address: String
    let telNo: String
    
    var hasSleepingRoom: Bool {
        return convenience.contains("수면실")
    }
    var hasShowerRoom: Bool {
        return convenience.contains("샤워실")
    }
    var hasLaundryRoom: Bool {
        return convenience.contains("세탁실")
    }
    var hasRestArea: Bool {
        return convenience.contains("쉼터")
    }
    var hasMarket: Bool {
        return convenience.contains("농산물판매장")
    }
    var fullName: String {
        return name + "휴게소"
    }
    var gasStationFullName: String {
        return name + "주유소"
    }
}

extension ServiceArea: Hashable {
    static func == (lhs: ServiceArea, rhs: ServiceArea) -> Bool {
        lhs.id == rhs.id
    }
}
