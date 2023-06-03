//
//  CardViewModelTests.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import CoreLocation

final class CardViewModelTests: XCTestCase {
    private var viewModel: CardViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: CardViewModel.Input!
    private var output: CardViewModel.Output!
    
    override func setUpWithError() throws {
        viewModel = CardViewModel(coordinator: nil,
                                  useCase: MockCardUseCase(),
                                  highwayInfo: [HighwayInfo(name: "test", coordinate: [0, 0])]
        )
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func test_fetch_search_history() {
        let highway: HighwayInfo? = HighwayInfo(name: "기흥(부산)휴게소", coordinate: [0, 0])
        let serviceArea = ServiceArea(id: "test_id",
                                          name: "기흥(부산)휴게소",
                                          serviceAreaCode: "A00003",
                                          convenience: "수유실|샤워실|세탁실",
                                          direction: "부산",
                                          address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                                          telNo: "031-286-5001")
        let gas = GasStation(uuid: "test_gas_uuid",
                             name: "화성(서울)주유소",
                             dieselPrice: "1,340원",
                             gasolinePrice: "1,520원",
                             lpgPrice: "X",
                             telNo: "055-312-2862",
                             oilCompany: "SK")
        
        let resultObserver = scheduler.createObserver(([ServiceArea], [GasStation]).self)
        let selectedHighwayObservable = scheduler.createHotObservable([.next(10, highway)])
        
        input = CardViewModel.Input(selectedHighway: selectedHighwayObservable.asObservable(),
                                    selectedServiceArea: Observable.just(serviceArea))
        
        output = viewModel.transform(input: input)

        output.result
            .asObservable()
            .subscribe(resultObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(try output.result.toBlocking().first()?.0, [serviceArea])
        XCTAssertEqual(try output.result.toBlocking().first()?.1, [gas])
    }
    
    func test_return_highway_name() {
        let serviceArea = ServiceArea(id: "test_id",
                                          name: "기흥(부산)휴게소",
                                          serviceAreaCode: "A00003",
                                          convenience: "수유실|샤워실|세탁실",
                                          direction: "부산",
                                          address: "경기 용인시 기흥구공세로 173 기흥휴게소",
                                          telNo: "031-286-5001")
        
        let highwayObserver = scheduler.createObserver([HighwayInfo].self)
        
        input = CardViewModel.Input(selectedHighway: Observable.just(nil),
                                    selectedServiceArea: Observable.just(serviceArea))
        output = viewModel.transform(input: input)
        output.highway
            .asObservable()
            .subscribe(highwayObserver)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(highwayObserver.events, [
            .next(0, [HighwayInfo(name: "test", coordinate: [0, 0])]),
            .completed(0)
        ])
    }
}
