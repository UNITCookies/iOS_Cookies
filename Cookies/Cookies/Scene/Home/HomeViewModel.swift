//
//  HomeViewModel.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift

class HomeViewModel {
    private let service: APIServiceProtocol
    struct Input {
        let readLetter: Observable<String>
    }
    
    struct Output {
        let detailLetter: Observable<Model.Letter>
    }
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
}

extension HomeViewModel {
    func transform(input: HomeViewModel.Input) -> HomeViewModel.Output {
        let letter = input.readLetter
            .flatMapLatest { [weak self] id -> Observable<Model.Letter> in
                guard let self = self else { return .empty() }
                return self.service.fetchReadLetter(id: id)
            }
        
        return HomeViewModel.Output(detailLetter: letter)
    }
}
