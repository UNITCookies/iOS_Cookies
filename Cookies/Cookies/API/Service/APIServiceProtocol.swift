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
    func fetchPin(userLat: Double,
                  userLng: Double,
                  topRightLat: Double,
                  topRightLng: Double,
                  bottomLeftLat: Double,
                  bottomLeftLng: Double) -> Observable<Model.Pin>
    func writeLetter(content: String,
                     lat: Double,
                     lng: Double) -> Observable<Bool>
}


