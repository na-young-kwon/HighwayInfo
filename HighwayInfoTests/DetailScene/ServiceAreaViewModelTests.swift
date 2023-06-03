//
//  ServiceAreaViewModelTests.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/03.
//

import XCTest
import RxSwift
import RxTest

final class ServiceAreaViewModelTests: XCTestCase {
    private var viewModel: ServiceAreaViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: ServiceAreaViewModel.Input!
    private var output: ServiceAreaViewModel.Output!
    
    override func setUpWithError() throws {
        let serviceArea = ServiceArea(id: "test_id",
                                     name: "기흥(부산)휴게소",
                                     serviceAreaCode: "A00003",
                                     convenience: "수유실|샤워실|세탁실",
                                     direction: "부산",
                                     address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                                     telNo: "031-286-5001")
        viewModel = ServiceAreaViewModel(coordinator: nil,
                                                 useCase: MockServiceAreaUseCase(),
                                                 highwayName: "test_highway_name",
                                                 serviceArea: [serviceArea])
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func test_filter_service_area_for_selected_category() {
        let serviceAreaObserver = scheduler.createObserver([ServiceArea].self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        let serviceArea = ServiceArea(id: "test_id",
                                      name: "기흥(부산)휴게소",
                                      serviceAreaCode: "A00003",
                                      convenience: "수유실|샤워실|세탁실",
                                      direction: "부산",
                                      address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                                      telNo: "031-286-5001")
        
        input = ServiceAreaViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                           selectedCategory: Observable.just(Convenience.laundryRoom),
                                           selectedServiceArea: Observable.just(serviceArea))
        output = viewModel.transform(input: input)
        output.serviceArea
            .subscribe(serviceAreaObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(serviceAreaObserver.events, [
            .next(0, [
                serviceArea
            ])
        ])
    }
    
    func test_load_highway_name() {
        let highwayObserver = scheduler.createObserver(String.self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        let serviceArea = ServiceArea(id: "test_id",
                                      name: "",
                                      serviceAreaCode: "",
                                      convenience: "",
                                      direction: "",
                                      address: "",
                                      telNo: "")
        
        input = ServiceAreaViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                           selectedCategory: Observable.just(Convenience.laundryRoom),
                                           selectedServiceArea: Observable.just(serviceArea))
        
        output = viewModel.transform(input: input)
        output.highwayName
            .asObservable()
            .subscribe(highwayObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(highwayObserver.events, [
            .next(0, "test_highway_name 고속도로 휴게소")
        ])
    }
}
