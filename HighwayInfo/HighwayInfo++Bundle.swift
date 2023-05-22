//
//  HighwayInfo++Bundle.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/17.
//

import Foundation

extension Bundle {
    var mapViewApiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY_MapView"] as? String
        else {
            fatalError("API키가 없습니다.")
        }
        return key
    }
    
    var accidentApiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY_Accident"] as? String
        else {
            fatalError("API키가 없습니다.")
        }
        return key
    }
    
    var cctvApiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY_CCTV"] as? String
        else {
            fatalError("API키가 없습니다.")
        }
        return key
    }
    
    var tmapApiKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY_TMAP"] as? String
        else {
            fatalError("API키가 없습니다.")
        }
        return key
    }
    
    var serviceAreaKey: String {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY_ServiceArea"] as? String
        else {
            fatalError("API키가 없습니다.")
        }
        return key
    }
}

