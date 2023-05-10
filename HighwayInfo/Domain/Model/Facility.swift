//
//  Facility.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/10.
//

import Foundation

enum Facility: Int, CaseIterable {
    case foodMenu
    case convenienceList
    case brandList
    
    var stringValue: String {
        switch self {
        case .foodMenu:
            return "메뉴"
        case .convenienceList:
            return "편의시설"
        case .brandList:
            return "브랜드매장"
        }
    }
}
