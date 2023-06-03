//
//  FacilityViewModelTests.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/03.
//

import XCTest
import RxSwift
import RxTest

final class FacilityViewModelTests: XCTestCase {
    private var viewModel: FacilityViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: FacilityViewModel.Input!
    private var output: FacilityViewModel.Output!
    
    override func setUpWithError() throws {
        let service = ServiceArea(id: "test_id",
                                  name: "기흥(부산)휴게소",
                                  serviceAreaCode: "A00003",
                                  convenience: "수유실|샤워실|세탁실",
                                  direction: "부산",
                                  address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                                  telNo: "031-286-5001")
        viewModel = FacilityViewModel(coordinator: nil,
                                      useCase: MockFacilityUseCase(),
                                      serviceArea: service)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func test_transform_route_to_point() {
        guard let facility = Facility(rawValue: 0) else {
            return
        }
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        
        input = FacilityViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                        selectedFacility: Observable.just(facility))
        output = viewModel.transform(input: input)
        
        XCTAssertEqual(output.serviceArea, ServiceArea(id: "test_id",
                                                       name: "기흥(부산)휴게소",
                                                       serviceAreaCode: "A00003",
                                                       convenience: "수유실|샤워실|세탁실",
                                                       direction: "부산",
                                                       address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                                                       telNo: "031-286-5001"))
    }
    
    func test_fetch_convenience_list_for_service_area() {
        guard let facility = Facility(rawValue: 1) else {
            return
        }
        let convenienceListObserver = scheduler.createObserver([ConvenienceList].self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        let selectFacilityObservable = scheduler.createHotObservable([.next(10, facility)])
        
        input = FacilityViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                        selectedFacility: selectFacilityObservable.asObservable())
        output = viewModel.transform(input: input)
        output.convenienceList
            .asObservable()
            .subscribe(convenienceListObserver)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(convenienceListObserver.events, [])
    }
    
    func test_fetch_food_menu_for_service_area() {
        guard let facility = Facility(rawValue: 0) else {
            return
        }
        let foodMenuObserver = scheduler.createObserver([FoodMenu].self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        
        input = FacilityViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                        selectedFacility: Observable.just(facility))
        output = viewModel.transform(input: input)
        output.foodMenuList
            .asObservable()
            .subscribe(foodMenuObserver)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(foodMenuObserver.events, [])
    }
    
    func test_fetch_brand_list_for_service_area() {
        guard let facility = Facility(rawValue: 2) else {
            return
        }
        let brandListObserver = scheduler.createObserver([Brand].self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        let selectFacilityObservable = scheduler.createHotObservable([.next(20, facility)])
        
        input = FacilityViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                        selectedFacility: selectFacilityObservable.asObservable())
        output = viewModel.transform(input: input)
        output.brandList
            .asObservable()
            .subscribe(brandListObserver)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(brandListObserver.events, [])
    }
    
    func test_fetch_gas_station_for_service_area() {
        guard let facility = Facility(rawValue: 0) else {
            return
        }
        let gasStationObserver = scheduler.createObserver(GasStation.self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        
        input = FacilityViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                        selectedFacility: Observable.just(facility))
        output = viewModel.transform(input: input)
        output.gasStation
            .subscribe(gasStationObserver)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(gasStationObserver.events, [])
    }
}
