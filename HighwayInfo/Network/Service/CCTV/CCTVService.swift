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
    
    func fetchPreviewBy(x: Double, y: Double) -> Observable<CctvDTO?> {
        let request = CCTVRequest(cctvType: .preview,
                                  minX: x - 0.006,
                                  maxX: x + 0.006,
                                  minY: y - 0.006,
                                  maxY: y + 0.006)
        let result = apiProvider.performDataTask(with: request, decodeType: .cctv)
        return result
    }
    
    func fetchVideo(x: Double, y: Double) -> Observable<CctvDTO?> {
        let request = CCTVRequest(cctvType: .video,
                                  minX: x - 0.006,
                                  maxX: x + 0.006,
                                  minY: y - 0.006,
                                  maxY: y + 0.006)
        let result = apiProvider.performDataTask(with: request, decodeType: .cctv)
        return result
    }
}
