//
//  AccidentDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation

//struct ServiceResult: Decodable {
//    let msgHeader: String
//}
class AccidentDTO: Decodable {
    var routeID: String!
    var linkId: String!
    var spotId: String!
    var regSeq: String!
    var confirmDate: String!
    var startDate: String!
    var estEndDate: String!
    var endDate: String!
    var restrictType: String!
    var inciDesc: String!
    var inciPlace1: String!
    var inciPlace2: String!
    var coord_x: String!
    var coord_y: String!
}
