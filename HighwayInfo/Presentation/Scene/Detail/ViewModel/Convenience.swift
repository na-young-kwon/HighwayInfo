//
//  Convenience.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/05.
//

import Foundation

enum Convenience: Int, CaseIterable {
    case all
    case sleepingRoom
    case showerRoom
    case laundryRoom
    case restArea
    case market
    
    var imageName: String {
        switch self {
        case .all: return "all"
        case .sleepingRoom: return "sleeping"
        case .showerRoom: return "shower"
        case .laundryRoom: return "laundry"
        case .restArea: return "restArea"
        case .market: return "market"
        }
    }
    var stringValue: String {
        switch self {
        case .all: return "All"
        case .sleepingRoom: return "수면실"
        case .showerRoom: return "샤워실"
        case .laundryRoom: return "세탁실"
        case .restArea: return "쉼터"
        case .market: return "농산물판매장"
        }
    }
}
