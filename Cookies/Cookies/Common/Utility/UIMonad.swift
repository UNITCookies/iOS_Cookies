//
//  UIMonad.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

public protocol Completable: AnyObject {
    associatedtype R
    var completion: ((R) -> Void)! { get set }
}

extension Completable where Self: UIViewController {
    public func getStream(WithPresenter presenter: UIViewController, presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle = .coverVertical) -> Observable<R> {
        return Observable<R>.create { [unowned self] observer -> Disposable in
            self.completion = { value in
                observer.onNext(value)
                observer.onCompleted()
            }

            self.modalTransitionStyle = transitionStyle
            self.modalPresentationStyle = presentationStyle
     
            presenter.present(self, animated: true, completion: nil)
     
            return Disposables.create { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
