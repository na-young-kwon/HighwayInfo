//
//  Route.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/12.
//

import Foundation

struct Route {
    let id = UUID()
    let name: String
    let number: String
    let startNodeName: String
    let endNodeName: String
}

enum RouteList {
    static let kb = Route(name: "경부", number: "0010", startNodeName: "서울", endNodeName: "부산")
    static let sh = Route(name: "서해안", number: "0150", startNodeName: "서울", endNodeName: "목포")
    static let ph = Route(name: "평택화성", number: "0170", startNodeName: "안녕", endNodeName: "오성")
    static let kp = Route(name: "구리포천", number: "0290", startNodeName: "포천", endNodeName: "구리")
    static let jb = Route(name: "중부", number: "0352", startNodeName: "서울", endNodeName: "대전")
    static let secondJb = Route(name: "제2중부", number: "0370", startNodeName: "서울", endNodeName: "이천")
    static let pj = Route(name: "평택제천", number: "0400", startNodeName: "충주", endNodeName: "평택")
    static let jbInside = Route(name: "중부내륙", number: "0450", startNodeName: "양평", endNodeName: "마산")
    static let yd = Route(name: "영동", number: "0500", startNodeName: "인천", endNodeName: "강릉")
    static let yy = Route(name: "서울양양", number: "0600", startNodeName: "동홍천", endNodeName: "서울")
    static let circle = Route(name: "수도권 제1순환", number: "1000", startNodeName: "판교(구리)", endNodeName: "판교(일산)")
    static let secondGi = Route(name: "제2 경인", number: "1100", startNodeName: "성남", endNodeName: "안양")
    static let gi = Route(name: "경인", number: "1200", startNodeName: "서울", endNodeName: "인천")
    static let icn = Route(name: "인천국제공항", number: "1300", startNodeName: "고양", endNodeName: "인천")
    static let ps = Route(name: "평택시흥", number: "0153", startNodeName: "시흥", endNodeName: "평택")
    static let oh = Route(name: "오산화성", number: "0171", startNodeName: "오산", endNodeName: "화성")
    static let ys = Route(name: "용인서울", number: "1710", startNodeName: "서울", endNodeName: "용인")
    static let icnd = Route(name: "봉담동탄", number: "4000", startNodeName: "봉담", endNodeName: "동탄")
    static let ik = Route(name: "인천김포", number: "4002", startNodeName: "김포", endNodeName: "인천")
    static let bs = Route(name: "봉담송산", number: "4003", startNodeName: "송산", endNodeName: "봉담")
    static let hk = Route(name: "화성광주", number: "4004", startNodeName: "화성", endNodeName: "광주")
}

extension RouteList {
    static var allCases: [Route] {
        [ RouteList.kb, RouteList.sh, RouteList.ph, RouteList.kp, RouteList.jb,
          RouteList.secondJb, RouteList.pj, RouteList.jbInside, RouteList.yd, RouteList.yy,
          RouteList.circle, RouteList.secondGi, RouteList.gi, RouteList.icn, RouteList.ps,
          RouteList.oh, RouteList.ys, RouteList.icnd, RouteList.ik, RouteList.bs, RouteList.hk
        ]
    }
}
