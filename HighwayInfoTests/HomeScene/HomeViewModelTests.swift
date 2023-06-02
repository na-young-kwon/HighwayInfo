//
//  HighwayInfoTests.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/05/31.
//

import XCTest
import RxRelay
import RxSwift
import RxTest

final class HomeViewModelTests: XCTestCase {
    private var viewModel: HomeViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: HomeViewModel.Input!
    private var output: HomeViewModel.Output!
    private let dummyAccidents = [
        AccidentViewModel(
            id: "test_uuid",
            accident: Accident(
                startTime: "2023-04-05 14:46:00",
                place: "성남시 느티로",
                direction: "(양방향) 정자교",
                restrictType: "3차로",
                description: "[기타] 성남시 느티로 (양방향) 정자교  부분차로 통제,  다리붕괴",
                coord_x: 127.10897972,
                coord_y: 37.368456737335
            ), preview: "http://cctvsec.ktict.co.kr/1/u5AISOge0W/NNyObmnH6HUcAR9fmmzhfldx0XLmDZKuzNcw7xGUjIxoR32QechFVKqW6UtQOoaVBpIYPFMxm2w==",
            video: nil
        )
    ]
    
    override func setUpWithError() throws {
        viewModel = HomeViewModel(useCase: MockAccidentUseCase(), coordinator: nil)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func test_load_accidents() throws {
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        let refreshButtonTappedTestableObservable = scheduler.createHotObservable([.next(20, ())])
        let accidentObserver = scheduler.createObserver([AccidentViewModel].self)
        
        input = HomeViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                    refreshButtonTapped: refreshButtonTappedTestableObservable.asObservable())
        
        output = viewModel.transform(input: input)
        output.accidents.subscribe(accidentObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(accidentObserver.events, [
            .next(0, []),
            .next(10, dummyAccidents),
            .next(20, dummyAccidents)
        ])
    }
}
