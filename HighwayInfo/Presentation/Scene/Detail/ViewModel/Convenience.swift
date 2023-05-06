//
//  Convenience.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/05.
//

import Foundation

enum Convenience: Int, CaseIterable {
    case all
    case feedingRoom
    case sleepingRoom
    case showerRoom
    case laundryRoom
    
    var imageName: String {
        switch self {
        case .all: return "all"
        case .feedingRoom: return "feeding"
        case .sleepingRoom: return "sleeping"
        case .showerRoom: return "shower"
        case .laundryRoom: return "laundry"
        }
    }
    var stringValue: String {
        switch self {
        case .all: return "All"
        case .feedingRoom: return "수유실"
        case .sleepingRoom: return "수면실"
        case .showerRoom: return "샤워실"
        case .laundryRoom: return "세탁실"
        }
    }
}
