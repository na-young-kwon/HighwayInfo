//
//  ResultViewModelTests.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import XCTest
import RxSwift
import RxTest
import CoreLocation

final class ResultViewModelTests: XCTestCase {
    private var viewModel: ResultViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: ResultViewModel.Input!
    private var output: ResultViewModel.Output!
    
    override func setUpWithError() throws {
        let coordinate = CLLocationCoordinate2D(latitude: 37, longitude: 127)
        let highway = HighwayInfo(name: "test", coordinate: [10, 10])
        let cardViewModel = CardViewModel(coordinator: nil, useCase: MockCardUseCase(), highwayInfo: [])
        viewModel = ResultViewModel(coordinator: nil,
                                    route: Route(
                                        startPointName: "test_startPointName",
                                        endPointName: "test_endPointName",
                                        path: [coordinate],
                                        markerPoint: (coordinate, coordinate),
                                        highwayInfo: [highway]
                                    ),
                                    cardViewModel: cardViewModel
        )
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func test_transform_route_to_point() {
        let startPointObserver = scheduler.createObserver(String.self)
        let endPointObserver = scheduler.createObserver(String.self)
        let pathObserver = scheduler.createObserver([CLLocationCoordinate2D].self)
        let highwayInfoObserver = scheduler.createObserver([HighwayInfo].self)
        
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        
        input = ResultViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable())
        output = viewModel.transform(input: input)
        
        output.startPointName.asObservable().subscribe(startPointObserver).disposed(by: disposeBag)
        output.endPointName.asObservable().subscribe(endPointObserver).disposed(by: disposeBag)
        output.path.subscribe(pathObserver).disposed(by: disposeBag)
        output.highwayInfo.subscribe(highwayInfoObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(startPointObserver.events, [
            .next(0, "test_startPointName"),
            .completed(0)
        ])
        
        XCTAssertEqual(endPointObserver.events, [
            .next(0, "test_endPointName"),
            .completed(0)
        ])
        
        XCTAssertEqual(pathObserver.events, [
            .next(0, [CLLocationCoordinate2D(latitude: 37, longitude: 127)]),
            .completed(0)
        ])
        
        XCTAssertEqual(highwayInfoObserver.events, [
            .next(0, [HighwayInfo(name: "test", coordinate: [10, 10])]),
            .completed(0)
        ])
    }
}
