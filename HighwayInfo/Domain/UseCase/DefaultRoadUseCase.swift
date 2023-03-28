//
//  DefaultRoadUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift

final class DefaultRoadUseCase: RoadUseCase {
    private let roadRepository: RoadRepository
    private let disposeBag = DisposeBag()
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func fetchLocationInfo(for route: Route) {
        print("좌표정보 가져오기")
    }
}
