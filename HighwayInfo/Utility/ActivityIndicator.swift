//
//  ActivityIndicator.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/09.
//

import Foundation
import RxSwift
import RxCocoa

class ActivityIndicator: SharedSequenceConvertibleType {
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _behavior = BehaviorRelay<Bool>(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    init() {
        _loading = _behavior.asDriver()
            .distinctUntilChanged()
    }
    
    func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    
    func subscribed() {
        _lock.lock()
        _behavior.accept(true)
        _lock.unlock()
    }
    
    func sendStopLoading() {
        _lock.lock()
        _behavior.accept(false)
        _lock.unlock()
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
