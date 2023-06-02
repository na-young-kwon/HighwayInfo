//
//  RoadViewModelTests.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import XCTest
import RxSwift
import RxTest
import CoreLocation

final class RoadViewModelTests: XCTestCase {
    private var viewModel: RoadViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: RoadViewModel.Input!
    private var output: RoadViewModel.Output!
    
    override func setUpWithError() throws {
        viewModel = RoadViewModel(useCase: MockRoadUseCase(), coordinator: nil)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func test_location_authorization_start_with_not_determined() {
        let authorizationObserver = scheduler.createObserver(Bool.self)
        
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        input = RoadViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable())
        output = viewModel.transform(input: input)
        output.showAuthorizationAlert.subscribe(authorizationObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(authorizationObserver.events, [
            .next(0, false),
            .next(10, false)
        ])
    }
    
    func test_current_location() {
        let currentLocationObserver = scheduler.createObserver(CLLocationCoordinate2D.self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        
        input = RoadViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable())
        output = viewModel.transform(input: input)
        output.currentLocation.subscribe(currentLocationObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(currentLocationObserver.events, [
            .next(10, CLLocationCoordinate2D(latitude: 37, longitude: 127))
        ])
    }
}
