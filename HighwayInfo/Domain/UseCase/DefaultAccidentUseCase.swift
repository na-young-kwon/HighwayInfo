//
//  DefaultAccidentUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation
import RxSwift

final class DefaultAccidentUseCase: AccidentUseCase {
    let repository: AccidentRepository
    
    init(repository: AccidentRepository) {
        self.repository = repository
    }

    func fetchAllAccidents() -> RxSwift.Observable<Accident> {
        return Disposables.create() as! Observable<Accident>
    }
}
