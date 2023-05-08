//
//  DefaultServiceAreaUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/08.
//

import Foundation
import RxSwift

final class DefaultServiceAreaUseCase: ServiceAreaUseCase {
    func filterServiceArea(with serviceArea: [ServiceArea], for convenience: Convenience) -> [ServiceArea] {
        switch convenience {
        case .all:
            return serviceArea
        case .sleepingRoom:
            return serviceArea.filter { $0.sleepingRoom == true }
        case .showerRoom:
            return serviceArea.filter { $0.showerRoom == true }
        case .laundryRoom:
            return serviceArea.filter { $0.laundryRoom == true }
        case .restArea:
            return serviceArea.filter { $0.restArea == true }
        case .market:
            return serviceArea.filter { $0.market == true }
        }
    }
}