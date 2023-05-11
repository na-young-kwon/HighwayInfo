//
//  ConvenienceList.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/10.
//

import Foundation

struct ConvenienceList: Hashable {
    let uuid = UUID()
    let name: String
    private let startTime: String
    private let endTime: String
    
    init(name: String, startTime: String, endTime: String) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
    }
    
    var operatingTime: String {
        return startTime + " ~ " + endTime
    }
}
