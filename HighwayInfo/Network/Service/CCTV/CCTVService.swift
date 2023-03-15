//
//  CctvService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation
import RxSwift

final class CCTVService {
    let apiProvider: APIProvider
    
    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchPreviewBy(x: String, y: String) -> Observable<[CctvDTO]> {
        let coordx = Double(x) ?? 0
        let coordy = Double(y) ?? 0
        let request = CCTVRequest(cctvType: .preview,
                                  minX: coordx - 0.003,
                                  maxX: coordx + 0.003,
                                  minY: coordy - 0.003,
                                  maxY: coordy + 0.003)
        
        return apiProvider.performDataTask(with: request, decodeType: .json)
    }
}
