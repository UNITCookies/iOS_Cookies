//
//  BottomMenuView.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

final class BottomMenuView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet fileprivate weak var writeButton: UIButton!
    
    static func loadView() -> BottomMenuView {
        return Bundle.main.loadNibNamed(BottomMenuView.className,
                                        owner: self,
                                        options: nil)?.first as! BottomMenuView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 30
    }
}

extension Reactive where Base: BottomMenuView {
    var tappedWrite: ControlEvent<Void> {
        return ControlEvent(events: base
            .writeButton.rx.tap)
    }
}
