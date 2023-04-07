//
//  DefaultRoadUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultRoadUseCase: RoadUseCase {
    private let roadRepository: RoadRepository
    private let disposeBag = DisposeBag()
    
    var searchResult = PublishSubject<[LocationInfo]>()
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func fetchResult(for keyword: String) {
        roadRepository.fetchSearchResult(for: keyword)
            .map { $0.searchPoiInfo.pois.poi.map { LocationInfo(name: $0.name, address: $0.newAddressList.newAddress.first?.fullAddressRoad, businessName: $0.lowerBizName, distance: $0.id) }}
            .subscribe(onNext: { searchResult in
                self.searchResult.onNext(searchResult)
            })
            .disposed(by: disposeBag)
    }
}
