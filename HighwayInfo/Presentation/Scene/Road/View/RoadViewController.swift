//
//  RoadViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import TMapSDK
import CoreLocation

class RoadViewController: UIViewController, TMapViewDelegate {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var locationInputView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    var viewModel: RoadViewModel!
    private let disposeBag = DisposeBag()
    private var mapView: TMapView?
    private let apiKey = Bundle.main.mapViewApiKey
    private var position: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMapView()
        configureTapGesture()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureUI() {
        locationInputView.layer.cornerRadius = locationInputView.frame.size.height / 2
        locationInputView.layer.borderColor = UIColor.white.cgColor
        locationInputView.layer.borderWidth = 0.25
        locationInputView.backgroundColor = .white
        locationInputView.layer.shadowColor = UIColor.gray.cgColor
        locationInputView.layer.shadowOffset = .zero
        locationInputView.layer.shadowOpacity = 1
        locationInputView.layer.shadowRadius = 3
        currentLocationButton.backgroundColor = .white
        currentLocationButton.setImage(UIImage(systemName: "location.fill.viewfinder"), for: .normal)
        currentLocationButton.layer.cornerRadius = currentLocationButton.frame.width / 2
        currentLocationButton.layer.shadowColor = UIColor.gray.cgColor
        currentLocationButton.layer.shadowOffset = .zero
        currentLocationButton.layer.shadowOpacity = 1
        currentLocationButton.layer.shadowRadius = 3
    }
    
    private func configureMapView() {
        mapView = TMapView(frame: backgroundView.frame)
        mapView?.delegate = self
        mapView?.setApiKey(apiKey)
        backgroundView.addSubview(mapView!)
    }
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSearchView))
        locationInputView.addGestureRecognizer(tap)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
        let input = RoadViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.currentLocation
            .subscribe(onNext: { [weak self] location in
                self?.position = location
            })
            .disposed(by: disposeBag)
        
        output.showAuthorizationAlert
            .subscribe(onNext: { [weak self] showAlert in
                if showAlert { self?.setAuthAlertAction() }
            })
            .disposed(by: disposeBag)
    }
    
    private  func setAuthAlertAction() {
        let alert = UIAlertController(title: "위치정보 권한 요청",
                                      message: "경로탐색을 위한 위치정보가 필요합니다",
                                      preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }}
        )
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tap(_ sender: UIButton) {
        showCurrentLocation()
    }
    
    private func showCurrentLocation() {
        if let position = position {
            let marker = TMapCustomMarker(position: position)
            let view = UIImageView(image: UIImage(named: "marker"))
            marker.view = view
            mapView?.setCenter(position)
            mapView?.setZoom(17)
            marker.map = self.mapView
        }
    }
    
    @objc func showSearchView() {
        viewModel.showSearchView()
    }
}
