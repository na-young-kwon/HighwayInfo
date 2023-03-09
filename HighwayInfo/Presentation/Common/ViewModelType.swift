//
//  ViewModelType.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/09.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
