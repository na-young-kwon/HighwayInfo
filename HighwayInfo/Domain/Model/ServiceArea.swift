//
//  ServiceArea.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/02.
//

import Foundation

struct ServiceArea {
    let name: String
}

extension ServiceArea: Hashable {
    static func == (lhs: ServiceArea, rhs: ServiceArea) -> Bool {
        lhs.name == rhs.name
    }
}
