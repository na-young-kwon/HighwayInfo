//
//  CctvService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation
import RxSwift

struct CCTVService {
    let fetchPreview: (_ x: Double, _ y: Double) -> Observable<CctvDTO?>
    let fetchVideo: (_ x: Double, _ y: Double) -> Observable<CctvDTO?>
    
    init(fetchPreview: @escaping (_ x: Double, _ y: Double) -> Observable<CctvDTO?>,
         fetchVideo: @escaping (_ x: Double, _ y: Double) -> Observable<CctvDTO?>) {
        self.fetchPreview = fetchPreview
        self.fetchVideo = fetchVideo
    }
}

extension CCTVService {
    static let live = Self(
        fetchPreview: { x, y in
        return RouterManager<CCTVAPI>
            .init()
            .request(router: .fetchPreviewBy(x, y))
            .map({ data in
                let parser = CCTVParser(data: data)
                let decoded = parser.parseXML()
                return decoded
            })
            .asObservable()
        
    },
        fetchVideo: { x, y in
            return RouterManager<CCTVAPI>
                .init()
                .request(router: .fetchVideoBy(x, y))
                .map({ data in
                    let parser = CCTVParser(data: data)
                    let decoded = parser.parseXML()
                    return decoded
                })
                .asObservable()
            
        }
    )
}
