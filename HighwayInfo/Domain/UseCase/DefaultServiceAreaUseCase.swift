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
            return serviceArea.filter { $0.hasSleepingRoom }
        case .showerRoom:
            return serviceArea.filter { $0.hasShowerRoom }
        case .laundryRoom:
            return serviceArea.filter { $0.hasLaundryRoom }
        case .restArea:
            return serviceArea.filter { $0.hasRestArea }
        case .market:
            return serviceArea.filter { $0.hasMarket }
        }
    }
}
