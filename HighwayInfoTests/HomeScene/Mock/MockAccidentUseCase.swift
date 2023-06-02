//
//  MockAccidentUseCase.swift
//  HighwayInfoTests
//
//  Created by 권나영 on 2023/05/31.
//

import Foundation
import RxSwift

final class MockAccidentUseCase: AccidentUseCase {
    var accidents = BehaviorSubject<[AccidentViewModel]>(value: [])
    
    func fetchAccidents() {
        let mockAccident = [
            AccidentViewModel(
                id: "test_uuid",
                accident: Accident(
                    startTime: "2023-04-05 14:46:00",
                    place: "성남시 느티로",
                    direction: "(양방향) 정자교",
                    restrictType: "3차로",
                    description: "[기타] 성남시 느티로 (양방향) 정자교  부분차로 통제,  다리붕괴",
                    coord_x: 127.10897972,
                    coord_y: 37.368456737335
                ), preview: "http://cctvsec.ktict.co.kr/1/u5AISOge0W/NNyObmnH6HUcAR9fmmzhfldx0XLmDZKuzNcw7xGUjIxoR32QechFVKqW6UtQOoaVBpIYPFMxm2w==",
                video: nil
            )
        ]
        accidents.onNext(mockAccident)
    }
}
