//
//  HomeReactor.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/07.
//

import ReactorKit
import NMapsMap.NMFMapView

class HomeReactor: Reactor {
    private let service: APIServiceProtocol
    
    init (service: APIServiceProtocol) {
        self.service = service
    }
    
    enum Action {
        case moveMap(userLat: Double,
                     userLng: Double,
                     mapBounds: NMGLatLngBounds)
        case readLetter(id: String)
        case writeLetter(content: String,
                         lat: Double,
                         lng: Double)
    }
    
    // represent state changes
    enum Mutation {
        case setPin(Model.Pin)
        case setLetter(Model.Letter)
        case setWriteLetter(Bool)
    }
    
    // represents the current view state
    struct State {
        var pins: Model.Pin?
        var letter: Model.Letter?
        var toast: (String, String) = ("", "")
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveMap(let userLat,
                      let userLng,
                      let mapBounds):
            return self.service.fetchPin(userLat: userLat,
                                         userLng: userLng,
                                         topRightLat: mapBounds.northEastLat,
                                         topRightLng: mapBounds.northEastLng,
                                         bottomLeftLat: mapBounds.southWestLat,
                                         bottomLeftLng: mapBounds.southWestLng)
            .map { .setPin($0) }
            .debug("[HomeReactor] fetchPin")
            
        case .readLetter(let id):
            return self.service.fetchReadLetter(id: id)
                .map { .setLetter($0) }
            
        case .writeLetter(let content, let lat, let lng):
            return self.service.writeLetter(content: content,
                                            lat: lat,
                                            lng: lng)
            .map { .setWriteLetter($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPin(let pin):
            state.pins = pin
        case .setLetter(let letter):
            state.letter = letter
        case .setWriteLetter(let isSuccess):
            state.toast = isSuccess ? ("쿠키를 남겼습니다.", "한시간 후 다른 유저에게 발견됩니다") : ("쿠키 작성 실패", "잠시 후에 다시 시도해주세요.")
        }
        
        return state
    }
}
