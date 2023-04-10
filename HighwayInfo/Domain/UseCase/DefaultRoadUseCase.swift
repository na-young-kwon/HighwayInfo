//
//  DefaultRoadUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

enum LocationAuthorizationStatus {
    case allowed, notAllowed, notDetermined
}

final class DefaultRoadUseCase: RoadUseCase {
    var currentLocation = PublishSubject<CLLocation>()
    var authorizationStatus = BehaviorSubject<LocationAuthorizationStatus?>(value: nil)
    private let roadRepository: RoadRepository
    private let locationService: LocationService
    private let disposeBag = DisposeBag()
    
    var searchResult = PublishSubject<[LocationInfo]>()
    
    init(roadRepository: RoadRepository, locationService: LocationService) {
        self.roadRepository = roadRepository
        self.locationService = locationService
    }
    
    func checkAuthorization() {
        locationService.observeUpdatedAuthorization()
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.authorizationStatus.onNext(.allowed)
                    self?.locationService.start()
                case .notDetermined:
                    self?.authorizationStatus.onNext(.notDetermined)
                    self?.locationService.requestAuthorization()
                case .denied, .restricted:
                    self?.authorizationStatus.onNext(.notAllowed)
                @unknown default:
                    self?.authorizationStatus.onNext(nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observeLocation() {
        return locationService.currentLocation()
            .compactMap { $0.last }
            .subscribe(onNext: { [weak self] location in
                self?.currentLocation.onNext(location)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchResult(for keyword: String, coordinate: CLLocationCoordinate2D?) {
        // 이부분 에러처리해서 개선하기
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
