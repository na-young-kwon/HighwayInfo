//
//  GasStationParser.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

final class GasStationParser: NSObject, XMLParserDelegate {
    private let parser: XMLParser
    private var elementValue: String?
    private var gasStation: GasStationDTO!
    private var gasStations: [GasStationDTO] = []
    
    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> [GasStationDTO] {
        parser.parse()
        return gasStations
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "list" {
            gasStation = GasStationDTO()
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
            gasStations.append(gasStation)
        } else if elementName == "stdRestCd" {
            gasStation.serviceAreaCode = elementValue
        }
        elementValue = nil
    }
}
