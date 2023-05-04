//
//  ServiceArea.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/02.
//

import Foundation

struct ServiceArea {
    let uuid = UUID()
    let name: String
    let serviceAreaCode: String
    let convenience: String
    let direction: String
    let address: String
    let telNo: String
    
    var feedingRoom: Bool {
        return convenience.contains("수유실")
    }
    var sleepingRoom: Bool {
        return convenience.contains("수면실")
    }
    var showerRoom: Bool {
        return convenience.contains("샤워실")
    }
    var laundryRoom: Bool {
        return convenience.contains("세탁실")
    }
}

extension ServiceArea: Hashable {
    static func == (lhs: ServiceArea, rhs: ServiceArea) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
