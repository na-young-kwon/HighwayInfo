//
//  GasPriceDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

class GasPriceDTO: Decodable {
    var name: String!
    var dieselPrice: String!
    var gasolinePrice: String!
    var lpgPrice: String!
}
