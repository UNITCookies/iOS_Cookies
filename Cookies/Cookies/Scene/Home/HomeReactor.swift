//
//  HomeReactor.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/07.
//

import ReactorKit

class HomeReactor: Reactor {
    enum Action {
        case moveMap(userLat: Double,
                     userLng: Double,
                     topRightLat: Double,
                     topRightLng: Double,
                     bottomLeftLat: Double,
                     bottomLeftLng: Double)
        case readLetter(id: String)
        case writeLetter(content: String,
                         lat: Double,
                         lng: Double)
    }
    
    // represent state changes
    enum Mutation {
        case setPin([Model.Pin])
        case setLetter(Model.Letter)
        case setWriteLetter(Bool)
    }
    
    // represents the current view state
    struct State {
        var pins: [Model.Pin]?
        var letter: Model.Letter?
        var toast: String = ""
    }
    
    let initialState: State = State()
}
