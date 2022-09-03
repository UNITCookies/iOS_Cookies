//
//  HomeViewController.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

import Alamofire
import RxSwift
import RxCocoa
import NMapsMap
import CoreLocation

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var menuContainerView: UIView!
    @IBOutlet private weak var mapContainerView: UIView!
    
    private let userLocation    = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D())
    private let guideDismiss    = PublishSubject<String>()
    private let disposeBag      = DisposeBag()
    private let viewModel       = HomeViewModel(service: APIService())
    private let locationManager = CLLocationManager()
    private let menuView        = BottomMenuView.loadView()
    private let toast           = CookieToast()
    
    private lazy var naverMap: NMFMapView = NMFMapView(frame: self.view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManagerInit()
        self.setViews()
        self.presentGuideView()
        self.setBind()
        
        /*
         "curMemberX": 37.4952339,
         "curMemberY": 127.0382079,
         "startX": 37.4882018,
         "startY": 127.0314238,
         "endX": 37.5035999,
         "endY": 127.0486473
         */
//        let param = ["curMemberX": 37.4952339,
//                     "curMemberY": 127.0382079,
//                     "startX"    : 37.4882018,
//                     "startY"    : 127.0314238,
//                     "endX"      : 37.5035999,
//                     "endY"      : 127.0486473]
//
//        AF.request(URL(string: "http://43.200.232.27:8080/letter/map")!,
//                   method: .post,
//                   parameters: param).response { data in
//            print("\(data)")
//        }

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
        
        self.naverMap.positionMode = .direction
    }
    
    private func setViews() {
        self.view.addSubview(self.toast)
        self.view.bringSubviewToFront(self.toast)
        self.toast.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        self.menuContainerView.addSubview(self.menuView)
        self.mapContainerView.addSubview(self.naverMap)
        self.menuView.fillSuperview()
    }
    
    private func presentGuideView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            let guideView = GuideViewController.createInstance(self.guideDismiss)
            self.present(guideView, animated: true)
        }
    }
}

extension HomeViewController {
    private func setBind() {
        let writeLetter = PublishSubject<(content: String, lat: Double, lng: Double)>()
        let moveMap = PublishSubject<(userLat: Double,
                                      userLng: Double,
                                      topRightLat: Double,
                                      topRightLng: Double,
                                      bottomLeftLat: Double,
                                      bottomLeftLng: Double)>()
        self.naverMap.rx.mapViewRegionIsChanging
            .debug("[HomeViewController] mapViewRegionIsChanging")
            .subscribe(onNext: { region in
            
        }).disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.naverMap.rx.mapViewRegionDidChanging.startWith(0).map { [weak self] _ in return self?.naverMap }
            .unwrap(),
                                 self.userLocation.filter { $0.isValid })
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .debug("[HomeViewController] mapViewRegionDidChanging")
            .map { (mapView, location) in
                return (userLat: 37.4952339,
                        userLng: 127.0382079,
                        topRightLat: 37.4882018,
                        topRightLng: 127.0314238,
                        bottomLeftLat: 37.5035999,
                        bottomLeftLng: 127.0486473)
            }
            .bind(to: moveMap)
            .disposed(by: self.disposeBag)
        
        self.naverMap.rx.didTapMapView
            .debug("[HomeViewController] didTapMapView")
            .subscribe(onNext: {
            
        }).disposed(by: self.disposeBag)
        
        self.guideDismiss
            .debug("[HomeViewController] guideDismiss")
            .subscribe(onNext: { message in
            
        }).disposed(by: self.disposeBag)
        
        self.locationManager.rx.updateLocations
            .map{ $0.coordinate }
            .debug("[HomeViewController] updateLocations")
            .bind(to: self.userLocation)
            .disposed(by: self.disposeBag)
        
        let tappedWrite = self.menuView.rx.tappedWrite
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else { return .empty() }
                let messageView = WriteView.loadView()
                return AlertViewController.createInstance((contentView: messageView,
                                                           leftButtonTitle: nil,
                                                           rightButtonTitle: "쿠키 작성 완료"))
                    .getStream(WithPresenter: self, presentationStyle: .overCurrentContext)
                    .filter { $0 }
                    .map { _ in messageView.message }
            }
        
        Observable.merge(tappedWrite, self.guideDismiss)
            .withLatestFrom(self.userLocation) { ($0,$1) }
            .map { (message, loc) in
                return (content: message, lat: loc.latitude, lng: loc.longitude)
            }
            .bind(to: writeLetter)
            .disposed(by: self.disposeBag)
        
        let input = HomeViewModel.Input(readLetter: .just("1"),
                                        moveMap: moveMap.asObservable(),
                                        write: writeLetter.asObservable()
        )
        let output = self.viewModel.transform(input: input)
        
        output.pins
            .debug("pins")
            .subscribe(onNext: { pins in
                
            }).disposed(by: self.disposeBag)
        
        output.detailLetter
            .debug("[HomeViewController] detailLetter")
            .subscribe(onNext: { [weak self] letter in
                
            }).disposed(by: self.disposeBag)
        
        output.isWrite
            .debug("[HomeViewController] isWrite")
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.toast.show(title: "쿠키를 남겼습니다.",
                                     explain: "한시간 후 다른 유저에게 발견됩니다")
                }
            }).disposed(by: self.disposeBag)
    }
}

extension HomeViewController: VCFactorable {
    public static var storyboardIdentifier = "Main"
    public static var vcIdentifier = "HomeViewController"
    public func bindData(value: ()) {
        
    }
}
