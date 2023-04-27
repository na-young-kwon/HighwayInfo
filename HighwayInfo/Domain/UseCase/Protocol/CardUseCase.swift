//
//  ResultUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift

protocol CardUseCase {
    func fetchServiceArea(for routeName: String)
}
