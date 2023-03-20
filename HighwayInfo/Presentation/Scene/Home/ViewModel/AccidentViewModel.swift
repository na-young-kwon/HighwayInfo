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
    let coordx: Double
    let coordy: Double
    
    init(accident: Accident) {
        self.startTime = accident.startTime.toShortDate
        self.estimatedEndTime = accident.estimatedEndTime.toShortDate
        self.place = accident.place
        self.direction = accident.direction
        self.restrictType = accident.restrictType
        self.description = accident.description
        self.coordx = accident.coord_x
        self.coordy = accident.coord_y
    }
}

private extension String {
    var toShortDate: String {
        let stringFormat = "yyyy-MM-dd HH:mm:ss"
        let format = "a h:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormat
        dateFormatter.locale = Locale(identifier: "ko")
        let convertedDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: convertedDate!)
        return dateString
    }
}
