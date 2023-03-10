//
//  AccidentUseCase.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/08.
//

import Foundation
import RxSwift

protocol AccidentUseCase {
    func fetchAccidents(for road: Road)
    func fetchAccidents()
    func fetchConstructions()
}
