//
//  HomeViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap
import CoreLocation

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var menuContainerView: UIView!
    @IBOutlet private weak var mapContainerView: UIView!
    
    
    private let disposeBag      = DisposeBag()
    private let viewModel       = HomeViewModel(service: APIService())
    private let locationManager = CLLocationManager()
    private let menuView        = BottomMenuView.loadView()
    private lazy var naverMap: NMFMapView = NMFMapView(frame: self.view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManagerInit()
        self.setViews()
        self.presentGuideView()
        self.setBind()

//        Observable.just(())
//            .flatMap { _ -> Observable<Model.Letter> in
//                return API.ReadLetter(id: "1").request()
//            }.subscribe(onNext: { _ in
//            
//            }).disposed(by: self.disposeBag)
    }
}

extension HomeViewController {
    private func locationManagerInit() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func setViews() {
        self.menuContainerView.addSubview(self.menuView)
        self.mapContainerView.addSubview(self.naverMap)
        self.menuView.fillSuperview()
    }
    
    private func presentGuideView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let guideView = GuideViewController.createInstance(())
            self.present(guideView, animated: true)
        }
    }
}

extension HomeViewController {
    private func setBind() {
        self.naverMap.rx.mapViewRegionIsChanging
            .debug("[HomeViewController] mapViewRegionIsChanging")
            .subscribe(onNext: { region in
            
        }).disposed(by: self.disposeBag)
        
        self.naverMap.rx.mapViewRegionDidChanging
            .debug("[HomeViewController] mapViewRegionDidChanging")
            .subscribe(onNext: { region in
            
            }).disposed(by: self.disposeBag)
        
        self.naverMap.rx.didTapMapView
            .debug("[HomeViewController] didTapMapView")
            .subscribe(onNext: {
            
        }).disposed(by: self.disposeBag)
        
        self.locationManager.rx.updateLocations
            .map{ $0.coordinate }
            .debug("[HomeViewController] updateLocations")
            .subscribe(onNext: { coordinator in
                
            })
            .disposed(by: self.disposeBag)
        
        self.menuView.rx.tappedWrite
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else { return .empty() }
                let messageView = WriteView.loadView()
                return AlertViewController.createInstance(messageView)
                    .getStream(WithPresenter: self, presentationStyle: .overCurrentContext)
                    .filter { $0 }
                    .map { _ in messageView.message }
            }
            .subscribe(onNext: { message in
                print("message: \(message)")
            }).disposed(by: self.disposeBag)
        
        let input = HomeViewModel.Input(readLetter: .just("1"))
        let output = self.viewModel.transform(input: input)
        
        output.detailLetter
            .debug("[HomeViewController] detailLetter")
            .subscribe(onNext: { [weak self] letter in
            
            }).disposed(by: self.disposeBag)
    }
}

extension HomeViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier = "HomeViewController"
    public func bindData(value: ()) {
        
    }
}
