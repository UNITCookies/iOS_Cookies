//
//  APIService.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/04.
//

import RxSwift

class APIService: APIServiceProtocol {
    func fetchReadLetter(id: String) -> Observable<Model.Letter> {
        return API.ReadLetter(id: id).request()
    }
}
