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
    private var input: HomeViewModel.Input!
    private var output: HomeViewModel.Output!
    
    
    override func setUpWithError() throws {
       viewModel = HomeViewModel(useCase: MockAccidentUseCase(), coordinator: nil)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }

    func testExample() throws {
        
    }
}
