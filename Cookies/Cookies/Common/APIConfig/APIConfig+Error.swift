//
//  APIConfig+Error.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift

protocol APIConfigWithError: APIConfig { }

extension APIConfigWithError {
    func requestWithCatch() -> Observable<Result<Response, APIError<ServiceError>>> {
        return self.makeRequest().map(Result<Response, APIError<ServiceError>>.success)
            .catchError { error -> Observable<Result<Response, APIError<ServiceError>>> in
                guard let apiError = error as? APIError<ServiceError> else { throw error }
                
                return Observable.just(.failure(apiError))
        }
    }
}
