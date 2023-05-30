//
//  ResultUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/11.
//

import Foundation
import RxSwift

protocol CardUseCase {
    var serviceArea: PublishSubject<[ServiceArea]> { get }
    var gasStation: PublishSubject<[GasStation]> { get }
    func fetchService(for highway: HighwayInfo)
}
