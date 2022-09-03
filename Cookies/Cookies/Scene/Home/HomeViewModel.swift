//
//  HomeViewModel.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import RxSwift
/*
userLat: Double,
              userLng: Double,
              topLeftLat: Double,
              topLeftLng: Double,
              bottomRightLat: Double,
              bottomRightLng: Double
 */

class HomeViewModel {
    private let service: APIServiceProtocol
    struct Input {
        let readLetter: Observable<String>
        let moveMap   : Observable<(userLat: Double,
                                    userLng: Double,
                                    topRightLat: Double,
                                    topRightLng: Double,
                                    bottomLeftLat: Double,
                                    bottomLeftLng: Double)>
        let write     : Observable<(content: String, lat: Double, lng: Double)>
    }
    
    struct Output {
        let detailLetter: Observable<Model.Letter>
        let pins: Observable<Model.Pin>
        let isWrite: Observable<Bool>
    }
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
}

extension HomeViewModel {
    func transform(input: HomeViewModel.Input) -> HomeViewModel.Output {
        let letter = input.readLetter
            .debug("[HomeViewModel] input.readLetter")
            .flatMapLatest { [weak self] id -> Observable<Model.Letter> in
                guard let self = self else { return .empty() }
                return self.service.fetchReadLetter(id: id)
            }.debug("[HomeViewModel] fetchReadLetter")
        
        let pins = input.moveMap
            .flatMapLatest { [weak self] params -> Observable<Model.Pin> in
                guard let self = self else { return .empty() }
                return self.service.fetchPin(userLat: params.userLat,
                                             userLng: params.userLng,
                                             topRightLat: params.topRightLat,
                                             topRightLng: params.topRightLng,
                                             bottomLeftLat: params.bottomLeftLat,
                                             bottomLeftLng: params.bottomLeftLng)
            }
        
        let write = input.write
            .flatMapLatest { [weak self] letter -> Observable<Bool> in
                guard let self = self else { return .empty() }
                return self.service.writeLetter(content: letter.content, lat: letter.lat, lng: letter.lng)
        }
        
        return HomeViewModel.Output(detailLetter: letter,
                                    pins: pins,
                                    isWrite: write
        )
    }
}
