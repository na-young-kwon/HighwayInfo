//
//  AccidentUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/08.
//

import Foundation

protocol AccidentUseCase {
    func fetchAccidents()
    func fetchImage(for accidents: [Accident])
}
