//
//  ViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

import NMapsMap

class ViewController: UIViewController {
    private let viewModel  = ViewModel()
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var resultMessage: UILabel!
    @IBOutlet private weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBind()
        
        let naverMapView = NMFNaverMapView(frame: view.frame)
                view.addSubview(naverMapView)
    }
    
    private func setBind() {
        let trigger = self.testButton.rx.tap.asObservable()
        let input   = ViewModel.Input(trigger: trigger)
        
        let output = self.viewModel.transform(input: input)
        
        output.result
            .subscribe(onNext: { [weak self] message in
                self?.resultMessage.text = message
            }).disposed(by: self.disposeBag)
    }
}

extension ViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier = "ViewController"
    public func bindData(value: ()) {
        
    }
}
