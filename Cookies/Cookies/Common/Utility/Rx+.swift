//
//  Rx+.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/04.
//

import RxSwift

extension ObservableType {
    func unwrap<Result>() -> Observable<Result> where Element == Result? {
        return self.compactMap { $0 }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
