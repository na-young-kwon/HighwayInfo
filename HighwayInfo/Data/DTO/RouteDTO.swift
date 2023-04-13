//
//  RouteDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/12.
//

import Foundation

struct RouteDTO: Decodable {
    let type: String
    let features: [Feature]
}

struct Feature: Decodable {
    let type: String
    let geometry: Geometry
    let properties: Properties
}

struct Geometry: Decodable {
    let type: String
    let coordinates: [Coordinate]
//    let traffic: [[Int]]?
}

enum Coordinate: Decodable {
    case double(Double)
    case doubleArray([Double])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Double].self) {
            self = .doubleArray(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        throw DecodingError.typeMismatch(Coordinate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Coordinate"))
    }
}

struct Properties: Decodable {
    let index: Int
    let name, description: String
    let nextRoadName, pointType: String?
    let totalDistance, totalTime, totalFare: Int?
    let taxiFare, pointIndex, turnType, lineIndex: Int?
    let distance, time, roadType, facilityType: Int?
}
