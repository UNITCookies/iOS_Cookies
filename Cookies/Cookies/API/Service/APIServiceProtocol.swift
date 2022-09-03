//
//  APIService.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift
import RxCocoa

protocol APIServiceProtocol {
    func fetchReadLetter(id: String) -> Observable<Model.Letter>
}


