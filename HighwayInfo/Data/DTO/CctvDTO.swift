//
//  CctvDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation

struct CctvDTO: Decodable {
    let response: Response
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct Response: Decodable {
    let coordType: Int
    let data: Cctv?
    let dataCount: Int
    
    enum CodingKeys: String, CodingKey {
        case coordType = "coordtype"
        case dataCount = "datacount"
        case data
    }
}

struct Cctv: Decodable {
     let roadSectionId: String
     let coordX: Double
     let coordY: Double
     let cctvResolution: String
     let fileCreateTime: String
     let cctvType: Int
     let cctvFormat: String
     let cctvName: String
    let cctvURL: String
    
    enum CodingKeys: String, CodingKey {
        case roadSectionId = "roadsectionid"
        case coordX = "coordx"
        case coordY = "coordy"
        case cctvResolution = "cctvresolution"
        case fileCreateTime = "filecreatetime"
        case cctvType = "cctvtype"
        case cctvFormat = "cctvformat"
        case cctvName = "cctvname"
        case cctvURL = "cctvurl"
    }
}

// Cctv? 로 파싱했을 떄
//"{\"response\":{\"coordtype\":1,\"data\":[{\"roadsectionid\":\"\",\"coordx\":127.008514404296,\"coordy\":37.310733795166,\"cctvresolution\":\"\",\"filecreatetime\":\"\",\"cctvtype\":3,\"cctvformat\":\"JPEG\",\"cctvname\":\"[영동선] 하강교\",\"cctvurl\":\"http://cctvsec.ktict.co.kr:8090/3715/zEGIWBWVxM3dCEQcSaYsIcskVY/qRtU/Q0jpIQWHKRKk1VU/rLJClaDEiM/bosd2d9t+5W6+Y/qWEf6z0zeNBg==\"},
//
//{\"roadsectionid\":\"\",\"coordx\":127.0034566,\"coordy\":37.31261583,\"cctvresolution\":\"\",\"filecreatetime\":\"\",\"cctvtype\":3,\"cctvformat\":\"JPEG\",\"cctvname\":\"[영동선] 파장육교\",\"cctvurl\":\"http://cctvsec.ktict.co.kr:8090/2653/EHxlD54HzwheGPUDGq1yYu0WeNFPXyR79UjBf/NM7cqpT5esl108WVwxnqniRa4t6SSj8oI1TehsWwFIpSXO9w==\"}],\"datacount\":2}}"


// data: [Cctv]? 일때
//
//"{\"response\":{\"coordtype\":1,\"data\":{\"roadsectionid\":\"\",\"coordx\":126.990116493293,\"coordy\":37.4051186075688,\"cctvresolution\":\"\",\"filecreatetime\":\"\",\"cctvtype\":3,\"cctvformat\":\"JPEG\",\"cctvname\":\"[안양성남선] 북의왕IC(안양)\",\"cctvurl\":\"http://cctvsec.ktict.co.kr:8090/5464/fLlWj13BPZciitvxKGl+s+xXI7XA3ZN1i7HFFhQwVQCTIgbnnIYebOnRDJtlhlBt46bX0IGBl9po4vknO7VQvA==\"},\"datacount\":1}}"
//

// [Cctv?] 일때

//"{\"response\":{\"coordtype\":1,\"data\":{\"roadsectionid\":\"\",\"coordx\":126.990116493293,\"coordy\":37.4051186075688,\"cctvresolution\":\"\",\"filecreatetime\":\"\",\"cctvtype\":3,\"cctvformat\":\"JPEG\",\"cctvname\":\"[안양성남선] 북의왕IC(안양)\",\"cctvurl\":\"http://cctvsec.ktict.co.kr:8090/5464/fLlWj13BPZciitvxKGl+s+xXI7XA3ZN1i7HFFhQwVQCTIgbnnIYebOnRDJtlhlBtNQgAdtOp6JSyLbDT58awAg==\"},\"datacount\":1}}"
