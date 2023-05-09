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
        if elementName == "list" {
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

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "list" {
            serviceAreas.append(serviceArea)
        } else if elementName == "serviceAreaName" {
            serviceArea.serviceAreaName = elementValue
        } else if elementName == "serviceAreaCode2" {let aaa = incrementNumericString(numericString: elementValue ?? "")
            serviceArea.serviceAreaCode = elementValue
            serviceArea.gasStationCode = aaa!
        } else if elementName == "convenience" {
            serviceArea.convenience = elementValue
        } else if elementName == "direction" {
            serviceArea.direction = elementValue
        } else if elementName == "svarAddr" {
            serviceArea.address = elementValue
        } else if elementName == "telNo" {
            serviceArea.telNo = elementValue
        }
        elementValue = nil
    }
    
    private func incrementNumericString(numericString: String) -> String? {
        guard let numericValue = Int(numericString) else { return nil }
        return String(format: "%.6ld", numericValue + 1)
    }
}
