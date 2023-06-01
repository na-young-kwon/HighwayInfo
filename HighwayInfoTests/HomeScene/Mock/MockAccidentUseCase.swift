//
//  MockAccidentUseCase.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/05/31.
//

import Foundation
import RxSwift

final class MockAccidentUseCase: AccidentUseCase {
    var accidents = RxSwift.BehaviorSubject<[AccidentViewModel]>(value: [])
    
    func fetchAccidents() {
        
    }
    
    func fetchImage(for accidents: [Accident]) {
        
    }
}
