//
//  TabBarPage.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import Foundation

enum TabBarPage: CaseIterable {
    case home, search
    
    init?(index: Int) {
        switch index {
            case 0: self = .home
            case 1: self = .search
            default: return nil
        }
    }
    
    var pageNumber: Int {
        switch self {
            case .home: return 0
            case .search: return 1
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "hi"
        case .search:
            return "high"
        }
    }
    
    var stringValue: String {
        switch self {
        case .home:
            return "홈"
        case .search:
            return "고속도로"
        }
    }
}
