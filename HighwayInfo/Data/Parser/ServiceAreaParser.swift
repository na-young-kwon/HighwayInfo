//
//  ServiceAreaParser.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/27.
//

import Foundation

final class ServiceAreaParser: NSObject, XMLParserDelegate {
    private let parser: XMLParser
    private var elementValue: String?
    private var serviceArea: ServiceAreaDTO!
    private var serviceAreas: [ServiceAreaDTO] = []
    
    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> [ServiceAreaDTO] {
        parser.parse()
        return serviceAreas
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "data" {
            serviceArea = ServiceAreaDTO()
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
            serviceAreas.append(serviceArea)
        } else if elementName == "serviceAreaName" {
            serviceArea.serviceAreaName = elementValue?.replacingOccurrences(of: "\n\t\t", with: "")
        } else if elementName == "serviceAreaCode2" {
            serviceArea.serviceAreaCode = elementValue?.replacingOccurrences(of: "\n\t\t", with: "")
        } else if elementName == "convenience" {
            serviceArea.convenience = elementValue?.replacingOccurrences(of: "\n\t\t", with: "")
        } else if elementName == "direction" {
            serviceArea.direction = elementValue?.replacingOccurrences(of: "\n\t\t", with: "")
        } else if elementName == "svarAddr" {
            serviceArea.address = elementValue?.replacingOccurrences(of: "\n\t\t", with: "")
        } else if elementName == "telNo" {
            serviceArea.telNo = elementValue?.replacingOccurrences(of: "\n\t\t", with: "")
        }
        elementValue = nil
    }
}
