//
//  AccidentService.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation
import RxSwift

struct AccidentService {
    let fetchAccidents: () -> Observable<[AccidentDTO]>
    
    init(fetchAccidents: @escaping () -> Observable<[AccidentDTO]>) {
        self.fetchAccidents = fetchAccidents
    }
}

extension AccidentService {
    static let live = Self(
        fetchAccidents: {
            return RouterManager<AccidentAPI>
                .init()
                .request(router: .getAccidents)
                .map({ data in
                    let parser = AccidentParser(data: data)
                    let decoded = parser.parseXML()
                    return decoded
                })
                .asObservable()
        }
    )
}
