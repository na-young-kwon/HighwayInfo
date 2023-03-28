//
//  Observable+Ext.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/09.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
