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
    private let tappedMarker    = BehaviorRelay<NMFOverlay?>(value: nil)
    private let readLetter      = PublishSubject<(String, Int)>()
    
    private let disposeBag      = DisposeBag()
    private let viewModel       = HomeViewModel(service: APIService())
    private let locationManager = CLLocationManager()
    private let menuView        = BottomMenuView.loadView()
    private let toast           = CookieToast()
    private var marker          = Set<NMFMarker>()
    private lazy var naverMap: NMFMapView = NMFMapView(frame: self.view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManagerInit()
        self.setViews()
        self.presentGuideView()
        self.setBind()
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
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .debug("[HomeViewController] mapViewRegionDidChanging")
            .map { (mapView, location) in
                return (userLat: location.latitude,
                        userLng: location.longitude,
                        topRightLat: mapView.contentBounds.northEastLat,
                        topRightLng: mapView.contentBounds.northEastLng,
                        bottomLeftLat: mapView.contentBounds.southWestLat,
                        bottomLeftLng: mapView.contentBounds.southWestLng)
//                return (userLat: 37.4952339,
//                        userLng: 127.0382079,
//                        topRightLat: 37.4882018,
//                        topRightLng: 127.0314238,
//                        bottomLeftLat: 37.5035999,
//                        bottomLeftLng: 127.0486473)
            }
            .bind(to: moveMap)
            .disposed(by: self.disposeBag)
        
        self.naverMap.rx.didTapMapView
            .debug("[HomeViewController] didTapMapView")
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.marker.filter { $0.userInfo["isAble"] as! Bool }.forEach { marker in
                    marker.iconImage = NMFOverlayImage(image: UIImage(named: "unSelectPin")!)
                }
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
        
        self.tappedMarker
            .subscribe(onNext: { [weak self] overlay in
                guard let self = self else { return }
                self.marker.filter { $0.userInfo["isAble"] as! Bool }.forEach { marker in
                    marker.iconImage = NMFOverlayImage(image: UIImage(named: "unSelectPin")!)
                }
                
                if let marker = overlay as? NMFMarker {
                    marker.iconImage = NMFOverlayImage(image: UIImage(named: "selectPin")!)
                    let id = String(marker.userInfo["id"] as! Int)
                    let count = marker.userInfo["count"] as! Int
                    self.readLetter.onNext((id, count))
                }
                
            }).disposed(by: self.disposeBag)
        
        let confirmRead = self.readLetter
            .flatMapLatest { [weak self] letter -> Observable<String> in
                guard let self = self else { return .empty() }
                let cookieView = CheckCookieView()
                cookieView.setEnableCount(count: letter.1)
                return AlertViewController.createInstance((contentView: cookieView,
                                                           leftButtonTitle: nil,
                                                           rightButtonTitle: "쿠키 줍기"))
                .getStream(WithPresenter: self, presentationStyle: .overCurrentContext)
                .filter { $0 }
                .map { _ in letter.0 }
            }
        
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
        
        let input = HomeViewModel.Input(readLetter: confirmRead.asObservable(),
                                        moveMap: moveMap.asObservable(),
                                        write: writeLetter.asObservable()
        )
        let output = self.viewModel.transform(input: input)
        
        output.pins
            .debug("pins")
            .subscribe(onNext: { [weak self] pins in
                guard let self = self else { return }
                self.marker.forEach { marker in
                    marker.mapView = nil
                }
                
                pins.disablePin.forEach { cookie in
                    let marker = NMFMarker()
                    marker.position = NMGLatLng(lat: cookie.lat, lng: cookie.lng)
                    marker.mapView = self.naverMap
                    marker.iconImage = NMFOverlayImage(image: UIImage(named: "disablePin")!)
                    marker.userInfo = ["isAble": false,
                                       "id": cookie.id,
                                       "count": cookie.enableCount
                    ]
                    self.marker.insert(marker)
                }
                
                pins.enablePin.forEach { cookie in
                    let marker = NMFMarker()
                    marker.position = NMGLatLng(lat: cookie.lat, lng: cookie.lng)
                    marker.mapView = self.naverMap
                    marker.iconImage = NMFOverlayImage(image: UIImage(named: "unSelectPin")!)
                    marker.userInfo = ["isAble": true,
                                       "id": cookie.id,
                                       "count": cookie.enableCount]
                    marker.touchHandler = { [weak self] overlay in
                        self?.tappedMarker.accept(overlay)
                        return true
                    }
                    
                    self.marker.insert(marker)
                }
            }).disposed(by: self.disposeBag)
        
        output.detailLetter
            .debug("[HomeViewController] detailLetter")
            .flatMapLatest({ [weak self] letter -> Observable<Void> in
                guard let self = self else { return .empty() }
                let writeView = WriteView.loadView()
                writeView.isRead(name: letter.nickname,
                                 content: letter.content,
                                 enableCount: letter.enableCount)
                
                return AlertViewController.createInstance((contentView: writeView,
                                                           leftButtonTitle: nil,
                                                           rightButtonTitle: "쿠키 줍줍 완료!"))
                    .getStream(WithPresenter: self, presentationStyle: .overCurrentContext)
                    .mapToVoid()
            })
            .subscribe(onNext: { [weak self] in
                self?.marker.filter { $0.userInfo["isAble"] as! Bool }.forEach { marker in
                    marker.iconImage = NMFOverlayImage(image: UIImage(named: "unSelectPin")!)
                }
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
