//
//  SearchResultDTO.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/06.
//

import Foundation

struct SearchResultDTO: Decodable {
    let searchPoiInfo: SearchPoiInfo
    
    // MARK: - SearchPoiInfo
    struct SearchPoiInfo: Decodable {
        let totalCount, count, page: String
        let pois: Pois
    }
    
    // MARK: - Pois
    struct Pois: Decodable {
        let poi: [Poi]
    }
    
    // MARK: - Poi
    struct Poi: Decodable {
        let id, pkey, navSeq, collectionType: String
        let name, telNo, frontLat, frontLon: String
        let noorLat, noorLon: String
        let upperAddrName, middleAddrName, lowerAddrName: String
        let detailAddrName, mlClass, firstNo, secondNo: String
        let roadName, firstBuildNo, secondBuildNo, radius: String
        let bizName, upperBizName, middleBizName, lowerBizName: String
        let detailBizName, rpFlag, parkFlag, detailInfoFlag: String
        let desc, dataKind, zipCode, adminDongCode: String
        let legalDongCode: String
        let newAddressList: NewAddressList
        let evChargers: EvChargers
    }
    
    // MARK: - NewAddressList
    struct NewAddressList: Decodable {
        let newAddress: [NewAddress]
    }
    
    // MARK: - NewAddress
    struct NewAddress: Decodable {
        let centerLat, centerLon, frontLat, frontLon: String
        let roadName, bldNo1, bldNo2, roadId, fullAddressRoad: String
    }
    
    // MARK: - EvChargers
    struct EvChargers: Decodable {
        let evCharger: [EvCharger]
    }

    // MARK: - EvCharger
    struct EvCharger: Decodable {
        let operatorId, stationId, chargerId, status: String
        let type, powerType, operatorName, chargingDateTime: String
        let updateDateTime, isFast, isAvailable: String
    }
}
