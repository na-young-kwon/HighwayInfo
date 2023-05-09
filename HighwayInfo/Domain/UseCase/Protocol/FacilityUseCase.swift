//
//  FacilityUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/09.
//

import Foundation
import RxSwift

protocol FacilityUseCase {
    func fetchGasPrice(for name: String)
}
