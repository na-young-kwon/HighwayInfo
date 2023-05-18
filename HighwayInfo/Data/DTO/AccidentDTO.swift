//
//  AccidentDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation

class AccidentDTO: Decodable {
    var startDate: String!
    var restrictType: String!
    var inciDesc: String!
    var inciPlace1: String!
    var inciPlace2: String!
    var coord_x: String!
    var coord_y: String!
    
    var toDomain: Accident {
        return Accident(startTime: startDate,
                        place: inciPlace1,
                        direction: inciPlace2.removeDirection(),
                        restrictType: restrictType,
                        description: inciDesc,
                        coord_x: Double(coord_x) ?? 0,
                        coord_y: Double(coord_y) ?? 0
        )
    }
}

extension String {
    func removeDirection() -> String {
        guard let startPoint = self.firstIndex(of: " ") else {
            return self
        }
        return String(self[startPoint...])
    }
}
