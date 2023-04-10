//
//  DefaultSearchUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

final class DefaultSearchUseCase: SearchUseCase {
    private let roadRepository: RoadRepository
    private let disposeBag = DisposeBag()
    var searchResult = PublishSubject<[LocationInfo]>()
    
    init(roadRepository: RoadRepository) {
        self.roadRepository = roadRepository
    }
    
    func fetchResult(for keyword: String, coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        roadRepository.fetchSearchResult(for: keyword, coordinate: coordinate)
            .map { $0.searchPoiInfo.pois.poi.map {
                LocationInfo(name: $0.name,
                             businessName: $0.lowerBizName,
                             distance: $0.radius,
                             coordx: $0.frontLon,
                             coordy: $0.frontLat,
                             address: $0.newAddressList.newAddress.first?.fullAddressRoad) }
            }
            .subscribe(onNext: { searchResult in
                self.searchResult.onNext(searchResult)
            })
            .disposed(by: disposeBag)
    }
    
}
