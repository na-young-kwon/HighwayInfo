//
//  Route.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/12.
//

import Foundation

struct Route {
    enum Axis {
        case vertical, horizontal
    }
    let id = UUID()
    let name: String
    let number: String
    let startNodeName: String
    let endNodeName: String
    let axis: Axis
}

enum RouteList {
    static let kb = Route(name: "경부", number: "0010", startNodeName: "서울", endNodeName: "부산", axis: .vertical)
    static let sh = Route(name: "서해안", number: "0150", startNodeName: "서울", endNodeName: "목포", axis: .vertical)
    static let ph = Route(name: "평택화성", number: "0171", startNodeName: "안녕", endNodeName: "오성", axis: .vertical)
    static let jb = Route(name: "제2중부", number: "0370", startNodeName: "서울", endNodeName: "이천", axis: .vertical)
    static let pj = Route(name: "평택제천", number: "0400", startNodeName: "제천", endNodeName: "평택", axis: .horizontal)
    static let jn = Route(name: "중부내륙", number: "0450", startNodeName: "양평", endNodeName: "마산", axis: .vertical)
    static let yd = Route(name: "영동", number: "0500", startNodeName: "인천", endNodeName: "강릉", axis: .horizontal)
    static let yy = Route(name: "서울양양", number: "0600", startNodeName: "동홍천", endNodeName: "서울", axis: .horizontal)
    static let circle = Route(name: "수도권 제1순환", number: "1000", startNodeName: "판교(구리)", endNodeName: "판교(일산)", axis: .horizontal)
    static let gi = Route(name: "경인", number: "1200", startNodeName: "서울", endNodeName: "인천", axis: .horizontal)
    static let bd = Route(name: "봉담동탄", number: "4000", startNodeName: "봉담", endNodeName: "동탄", axis: .horizontal)
}

extension RouteList {
    static var allCases: [Route] {
        [ RouteList.kb, RouteList.sh, RouteList.jb, RouteList.pj, RouteList.jn,
          RouteList.yd, RouteList.yy, RouteList.circle, RouteList.gi, RouteList.bd
        ]
    }
}
