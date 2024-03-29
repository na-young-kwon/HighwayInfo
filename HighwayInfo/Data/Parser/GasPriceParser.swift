//
//  GasPriceParser.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/28.
//

import Foundation

final class GasPriceParser: NSObject, XMLParserDelegate {
    private let parser: XMLParser
    private var elementValue: String?
    private var gasPrice: GasPriceDTO!
    
    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> GasPriceDTO? {
        parser.parse()
        return gasPrice
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "list" {
            gasPrice = GasPriceDTO()
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
        if elementName == "serviceAreaName" {
            gasPrice.name = elementValue
        }
        else if elementName == "diselPrice" {
            gasPrice.dieselPrice = elementValue
        }
        else if elementName == "gasolinePrice" {
            gasPrice.gasolinePrice = elementValue
        }
        else if elementName == "lpgPrice" {
            gasPrice.lpgPrice = elementValue
        }
        elementValue = nil
    }
}
