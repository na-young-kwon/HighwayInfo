//
//  AccidentViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/09.
//

import Foundation

struct AccidentViewModel {
    let startTime: String
    let estimatedEndTime: String
    let place: String
    let direction: String
    let restrictType: String
    let description: String
    
    init(accident: Accident) {
        self.startTime = accident.startTime
        self.estimatedEndTime = accident.estimatedEndTime
        self.place = accident.place
        self.direction = accident.direction
        self.restrictType = accident.restrictType
        self.description = accident.description
    }
}
