//
//  AccidentViewModel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/09.
//

import Foundation

struct AccidentViewModel: Identifiable, Hashable {
    static func == (lhs: AccidentViewModel, rhs: AccidentViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let startTime: String
    let place: String
    let direction: String
    let restrictType: String
    let description: String
    let coordx: Double
    let coordy: Double
    let preview: String?
    let video: String?
    
    init(accident: Accident, preview: String?, video: String?) {
        self.startTime = accident.startTime.toShortDate
        self.place = accident.place
        self.direction = accident.direction
        self.restrictType = accident.restrictType
        self.description = accident.description
        self.coordx = accident.coord_x
        self.coordy = accident.coord_y
        self.preview = preview
        self.video = video
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
