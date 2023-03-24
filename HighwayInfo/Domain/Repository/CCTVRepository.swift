//
//  CCTVRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/15.
//

import Foundation
import RxSwift

protocol CCTVRepository {
    func fetchPreviewBy(x: Double, y: Double) -> Observable<CctvDTO?>
    func fetchVideo(x: Double, y: Double) -> Observable<CctvDTO?>
}
