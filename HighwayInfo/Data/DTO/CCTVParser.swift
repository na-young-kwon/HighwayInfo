//
//  CCTVParser.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/21.
//

import Foundation

final class CCTVParser: NSObject, XMLParserDelegate {
    private let parser: XMLParser
    private var elementValue: String?
    private var cctv: CctvDTO!
    private var cctvs: [CctvDTO] = []
    
    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> CctvDTO? {
        parser.parse()
        return cctvs.first
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "data" {
            cctv = CctvDTO()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if elementValue == nil {
            elementValue = string
        } else {
            elementValue = "\(elementValue!)\(string)"
        }
    }

    // 닫는 태그를 만났을 때
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "data" {
            cctvs.append(cctv)
        } else if elementName == "cctvurl" {
            cctv.cctvurl = elementValue?.replacingOccurrences(of: "\n\t\t", with: "")
        }
        
        elementValue = nil
    }
}
