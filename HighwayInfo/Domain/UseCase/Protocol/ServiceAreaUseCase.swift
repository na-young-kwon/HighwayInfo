//
//  ServiceAreaUseCase.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/08.
//

import Foundation

protocol ServiceAreaUseCase {
    func filterServiceArea(with: [ServiceArea], for: Convenience) -> [ServiceArea]
}
