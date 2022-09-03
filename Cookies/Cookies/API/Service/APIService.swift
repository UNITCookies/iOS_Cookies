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
    
    func fetchPin(userLat: Double,
                  userLng: Double,
                  topRightLat: Double,
                  topRightLng: Double,
                  bottomLeftLat: Double,
                  bottomLeftLng: Double) -> Observable<Model.Pin> {
        return API.CookiesPin(userLat: userLat,
                              userLng: userLng,
                              topLeftLat: topRightLat,
                              topLeftLng: topRightLng,
                              bottomRightLat: bottomLeftLat,
                              bottomRightLng: bottomLeftLng).request()
    }
    
    func writeLetter(content: String,
                     lat: Double,
                     lng: Double) -> Observable<Bool> {
        return API.WriteLetter(content: content,
                               lat: lat,
                               lng: lng)
        .request()
    }
}
