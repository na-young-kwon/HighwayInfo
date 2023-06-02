//
//  SearchViewModelTests.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/06/02.
//

import XCTest
import RxSwift
import RxTest
import CoreLocation

final class SearchViewModelTests: XCTestCase {
    private var viewModel: SearchViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: SearchViewModel.Input!
    private var output: SearchViewModel.Output!
    
    override func setUpWithError() throws {
        viewModel = SearchViewModel(useCase: MockSearchUseCase(),
                                    coordinator: nil,
                                    currentLocation: CLLocationCoordinate2D(latitude: 37, longitude: 127))
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func test_fetch_search_history() {
        let searchHistoryObserver = scheduler.createObserver([LocationInfo].self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        
        input = SearchViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                      searchKeyword: Observable.just("seoul"),
                                      itemSelected: Observable.just(nil))
        output = viewModel.transform(input: input)
        output.searchHistory.subscribe(searchHistoryObserver).disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(searchHistoryObserver.events, [
            .next(10, [LocationInfo(
                uuid: "test_id",
                name: "botanic",
                businessName: "eroom",
                distance: "10",
                coordx: "10",
                coordy: "10",
                address: nil
            )])
        ])
    }
    
    func test_fetch_search_result() {
        let searchResultObserver = scheduler.createObserver([LocationInfo].self)
        let viewWillAppearTestableObservable = scheduler.createHotObservable([.next(10, ())])
        let keywordObservable = scheduler.createHotObservable([.next(20, "seoul")])
        
        input = SearchViewModel.Input(viewWillAppear: viewWillAppearTestableObservable.asObservable(),
                                      searchKeyword: keywordObservable.asObservable(),
                                      itemSelected: Observable.just(nil))
        output = viewModel.transform(input: input)
        output.searchResult.subscribe(searchResultObserver).disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(searchResultObserver.events, [
            .next(20, [LocationInfo(
                uuid: "test_id",
                name: "newLocation",
                businessName: "eroom",
                distance: "10",
                coordx: "10",
                coordy: "10",
                address: nil
            )])
        ])
    }
}
