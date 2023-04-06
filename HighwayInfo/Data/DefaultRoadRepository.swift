//
//  DefaultRoadRepository.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/28.
//

import Foundation
import RxSwift

final class DefaultRoadRepository: RoadRepository {
    private let service: RoadService
    
    init(service: RoadService) {
        self.service = service
    }
    
    func fetchSearchResult(for keyword: String) -> Observable<SearchResultDTO> {
        let request = SearchRequest(searchKeyword: keyword)
        return service.apiProvider.performDataTask(with: request, decodeType: .json)
    }
}
