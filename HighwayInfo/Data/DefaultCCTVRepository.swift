//
//  DefaultCCTVRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation
import RxSwift

final class DefaultCCTVRepository: CCTVRepository {
    private let service: CCTVService
    
    init(service: CCTVService) {
        self.service = service
    }
    
    func fetchPreviewBy(x: Double, y: Double) -> Observable<CctvDTO?> {
        service.fetchPreview(x, y)
    }
    
    func fetchVideo(x: Double, y: Double) -> Observable<CctvDTO?> {
        service.fetchVideo(x, y)
    }
}
