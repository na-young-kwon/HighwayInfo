//
//  AccidentRepository.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/08.
//

import Foundation
import RxSwift

protocol AccidentRepository {
    func fetchAllAccidents() -> Observable<[AccidentDTO]>
}
