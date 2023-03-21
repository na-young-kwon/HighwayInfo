//
//  XMLParser.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation

final class AccidentParser: NSObject, XMLParserDelegate {
    private let parser: XMLParser
    private var elementValue: String?
    private var accident: AccidentDTO!
    private var accidents: [AccidentDTO] = []
    
    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> [AccidentDTO] {
        parser.parse()
        return accidents
    }
    
    // 여는 태그를 만났을 때
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // 하나의 객체 여는 태그를 만났을 때 객체생성
        if elementName == "itemList" {
            accident = AccidentDTO()
        }
    }
    
    // 여는 태그와 닫는 태그 사이의 내용을 만났을 때
    // elementValue의 값이 nil이면 바로 저장하고
    // 그렇지않으면 이전 데이터에 추가한다
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if elementValue == nil {
            elementValue = string
        } else {
            elementValue = "\(elementValue!)\(string)"
        }
    }

    // 닫는 태그를 만났을 때
    // 객체를 배열이나 리스트에 저장하고, 객체 내의 태그를 만나면 그 태그에 해당하는 프로퍼티에 데이터를 저장한다
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "itemList" {
            accidents.append(accident)
        } else if elementName == "routeId" {
            accident.routeID = elementValue
        } else if elementName == "linkId" {
            accident.linkId = elementValue
        } else if elementName == "spotId" {
            accident.spotId = elementValue
        } else if elementName == "regSeq" {
            accident.regSeq = elementValue
        } else if elementName == "startDate" {
            accident.startDate = elementValue
        } else if elementName == "estEndDate" {
            accident.estEndDate = elementValue
        } else if elementName == "endDate" {
            accident.endDate = elementValue
        } else if elementName == "restrictType" {
            accident.restrictType = elementValue
        } else if elementName == "inciDesc" {
            accident.inciDesc = elementValue?.toShortDescription
        } else if elementName == "inciPlace1" {
            accident.inciPlace1 = elementValue
        } else if elementName == "inciPlace2" {
            accident.inciPlace2 = elementValue
        } else if elementName == "coord_x" {
            accident.coord_x = elementValue
        } else if elementName == "coord_y" {
            accident.coord_y = elementValue
        }
        
        elementValue = nil
    }
}

private extension String {
    var toShortDescription: String {
        let title = self.components(separatedBy: " ").first!
        let description = self.components(separatedBy: ",").last!
        return title + description
    }
}
