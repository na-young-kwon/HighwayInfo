//
//  AccidentUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation
import RxSwift

protocol AccidentUseCase {
    func fetchAccidents(for road: Road)
    func fetchAccidents()
    func fetchConstructions()
}
