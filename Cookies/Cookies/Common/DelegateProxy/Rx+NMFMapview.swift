//
//  Rx+NMFMapview.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import NMapsMap
import RxSwift
import RxCocoa

extension Reactive where Base: NMFMapView {
    var delegate: DelegateProxy<NMFMapView, NMFMapViewDelegate> {
        return RxNMFMapViewDelegateProxy.proxy(for: self.base)
    }
    
    var mapViewRegionIsChanging: Observable<Int> {
        return delegate.methodInvoked(#selector(NMFMapViewDelegate.mapViewRegionIsChanging(_:byReason:))).map { parameters in
            return parameters[1] as? Int ?? 0
        }
    }
    
    var mapViewRegionDidChanging: Observable<Int> {
        return delegate.methodInvoked(#selector(NMFMapViewDelegate.mapView(_:regionDidChangeAnimated:byReason:))).map { parameters in
            return parameters[2] as? Int ?? 0
        }
    }
    
    var didTapMapView: Observable<Void> {
        return delegate.methodInvoked(#selector(NMFMapViewDelegate.didTapMapView(_:latLng:))).map { _ in
            return ()
        }
    }
}

