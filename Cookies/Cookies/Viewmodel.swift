//
//  Viewmodel.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift
import RxCocoa

struct ViewModel {
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let result: Observable<String>
    }
}


extension ViewModel {
    func transform(input: ViewModel.Input) -> Output {
        let message = input.trigger
            .map {
                return "test message"
            }
        
        
        return Output(result: message)
    }
}
