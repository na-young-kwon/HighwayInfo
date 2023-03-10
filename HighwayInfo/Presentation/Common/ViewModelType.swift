//
//  ViewModelType.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/09.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
