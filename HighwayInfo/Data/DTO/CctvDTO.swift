//
//  CctvDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation

//struct CctvDTO: Decodable {
//    let response: Response
//
//    enum CodingKeys: String, CodingKey {
//        case response
//    }
//}
//
//struct Response: Decodable {
//    let coordType: Int
//    let data: Cctv?
//    let dataCount: Int
//
//    enum CodingKeys: String, CodingKey {
//        case coordType = "coordtype"
//        case dataCount = "datacount"
//        case data
//    }
//}
//
//struct Cctv: Decodable {
//     let roadSectionId: String
//     let coordX: Double
//     let coordY: Double
//     let cctvResolution: String
//     let fileCreateTime: String
//     let cctvType: Int
//     let cctvFormat: String
//     let cctvName: String
//    let cctvURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case roadSectionId = "roadsectionid"
//        case coordX = "coordx"
//        case coordY = "coordy"
//        case cctvResolution = "cctvresolution"
//        case fileCreateTime = "filecreatetime"
//        case cctvType = "cctvtype"
//        case cctvFormat = "cctvformat"
//        case cctvName = "cctvname"
//        case cctvURL = "cctvurl"
//    }
//}

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
//let roadSectionId: String
//     let coordX: Double
//     let coordY: Double
//     let cctvResolution: String
//     let fileCreateTime: String
//     let cctvType: Int
//     let cctvFormat: String
//     let cctvName: String
//    let cctvURL: String
//

class CctvDTO: Decodable {
    var cctvurl: String!
    var coordy: String!
    var cctvname: String!
    var coordx: String!
}


//<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<response>\r\n\t<coordtype>1</coordtype>\r\n\t<datacount>2</datacount>\r\n\t<data>\r\n\t\t<roadsectionid/>\r\n\t\t<filecreatetime/>\r\n\t\t<cctvtype>3</cctvtype>\r\n\t\t<cctvurl>http://cctvsec.ktict.co.kr:8090/739/wABhErdDzFQMwQPgLhEma8qfm0BSdSHjIQg/o/oXcZ1BsszVIpk/NCY98oN7NR1PpYKHKnSunADdY5XpYVb1GQ==</cctvurl>\r\n\t\t<cctvresolution/>\r\n\t\t<coordy>37.0459403991699</coordy>\r\n\t\t<cctvformat>JPEG</cctvformat>\r\n\t\t<cctvname>[중부선] 화봉육교1</cctvname>\r\n\t\t<coordx>127.477104187011</coordx>\r\n\t</data>\r\n\t<data>\r\n\t\t<roadsectionid/>\r\n\t\t<filecreatetime/>\r\n\t\t<cctvtype>3</cctvtype>\r\n\t\t<cctvurl>http://cctvsec.ktict.co.kr:8090/3264/BefFNpcC88/awUz7ULPPWWepnMQakW6BrzRk0kDVnZlQYHYVxlCI04KRu7E5qpGRr4+4sB9JAoj4R0oScGKBsw==</cctvurl>\r\n\t\t<cctvresolution/>\r\n\t\t<coordy>37.0502221</coordy>\r\n\t\t<cctvformat>JPEG</cctvformat>\r\n\t\t<cctvname>[중부선] 화봉육교</cctvname>\r\n\t\t<coordx>127.4763158</coordx>\r\n\t</data>\r\n</response>\r\n"




//"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><ServiceResult><comMsgHeader/><msgHeader><headerCd>0</headerCd><headerMsg>정상적으로 처리되었습니다.</headerMsg><itemCount>4</itemCount></msgHeader><msgBody><itemList><routeId></routeId><linkId>2260142300</linkId><spotId></spotId><regSeq>202301059559</regSeq><confirmDate>2023-01-05 08:49:00</confirmDate><startDate>2023-01-05 08:49:00</startDate><estEndDate>2023-03-21 15:25:00</estEndDate><endDate></endDate><restrictType>전차로</restrictType><inciDesc>[도로폐쇄] 제2경인고속도로(안양성남) (양방향) 북의왕IC → 삼막IC  전차로 통제,  사고처리</inciDesc><inciPlace1>제2경인고속도로(안양성남)</inciPlace1><inciPlace2>(양방향) 북의왕IC → 삼막IC</inciPlace2><coord_x>126.98676631</coord_x><coord_y>37.40685868730355</coord_y></itemList><itemList><routeId></routeId><linkId>1040000103</linkId><spotId></spotId><regSeq>202303216347</regSeq><confirmDate>2023-03-21 14:13:00</confirmDate><startDate>2023-03-21 14:13:00</startDate><estEndDate>2023-03-21 15:25:00</estEndDate><endDate></endDate><restrictType>4차로</restrictType><inciDesc>[차량고장] 강변북로 (구리방향) 잠실대교 → 잠실철교  4차로 통제,  차량고장</inciDesc><inciPlace1>강변북로</inciPlace1><inciPlace2>(구리방향) 잠실대교 → 잠실철교</inciPlace2><coord_x>127.08203126</coord_x><coord_y>37.52739696162846</coord_y></itemList><itemList><routeId></routeId><linkId>2810749100</linkId><spotId></spotId><regSeq>202303216348</regSeq><confirmDate>2023-03-21 14:28:00</confirmDate><startDate>2023-03-21 14:28:00</startDate><estEndDate>2023-03-21 15:25:00</estEndDate><endDate></endDate><restrictType>갓길</restrictType><inciDesc>[차량고장] 중부고속도로 (대전방향) 일죽IC → 대소JC  갓길 통제 ,  대형화물차 고장</inciDesc><inciPlace1>중부고속도로</inciPlace1><inciPlace2>(대전방향) 일죽IC → 대소JC</inciPlace2><coord_x>127.47621187</coord_x><coord_y>37.04978869497523</coord_y></itemList><itemList><routeId></routeId><linkId>2130001301</linkId><spotId></spotId><regSeq>202303217889</regSeq><confirmDate>2023-03-21 14:55:00</confirmDate><startDate>2023-03-21 14:55:00</startDate><estEndDate>2023-03-21 15:25:00</estEndDate><endDate></endDate><restrictType>1차로</restrictType><inciDesc>[차량고장] 서해안고속도로 (목포방향) 금천IC → 일직JC  1차로 통제,  차량고장</inciDesc><inciPlace1>서해안고속도로</inciPlace1><inciPlace2>(목포방향) 금천IC → 일직JC</inciPlace2><coord_x>126.89791101</coord_x><coord_y>37.43351625332727</coord_y></itemList></msgBody></ServiceResult>"
//
//(lldb)
