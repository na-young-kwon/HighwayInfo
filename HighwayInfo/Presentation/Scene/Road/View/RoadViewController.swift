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
    private let searchView = SearchView()
    private var mapView: TMapView?
    private let apiKey = "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    private var position: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMapView()
        configureTapGesture()
        bindViewModel()
    }
    
    private func configureUI() {
        locationInputView.layer.cornerRadius = locationInputView.frame.size.height / 2
        locationInputView.layer.borderColor = UIColor.white.cgColor
        locationInputView.layer.borderWidth = 0.25
        locationInputView.backgroundColor = .white
        locationInputView.layer.shadowColor = UIColor.gray.cgColor
        locationInputView.layer.shadowOffset = CGSize.zero
        locationInputView.layer.shadowOpacity = 1
        locationInputView.layer.shadowRadius = 3
        currentLocationButton.backgroundColor = .white
        currentLocationButton.setImage(UIImage(systemName: "location.fill.viewfinder"), for: .normal)
        currentLocationButton.layer.cornerRadius = currentLocationButton.frame.width / 2
        currentLocationButton.layer.shadowColor = UIColor.gray.cgColor
        currentLocationButton.layer.shadowOffset = CGSize.zero
        currentLocationButton.layer.shadowOpacity = 1
        currentLocationButton.layer.shadowRadius = 3
    }
    
    @IBAction func tap(_ sender: UIButton) {
        showCurrentLocation()
    }
    
    private func configureMapView() {
        mapView = TMapView(frame: backgroundView.frame)
        mapView?.delegate = self
        mapView?.setApiKey(apiKey)
        backgroundView.addSubview(mapView!)
    }
    
    private func configureSearchView() {
        view.addSubview(searchView)
        searchView.alpha = 0
        searchView.delegate = self
        searchView.viewModel = viewModel.searchViewModel
        searchView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height)
        
        UIView.animate(withDuration: 0.5) {
            self.searchView.alpha = 1
            self.searchView.textField.becomeFirstResponder()
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSearchView))
        locationInputView.addGestureRecognizer(tap)
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
        locationInputView.alpha = 0
        placeholderLabel.alpha = 0
        configureSearchView()
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
        let input = RoadViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.currentLocation
            .subscribe(onNext: { location in
                self.position = location
            })
            .disposed(by: disposeBag)
        
        output.showAuthorizationAlert
            .subscribe(onNext: { showAlert in
              print(showAlert)
            })
            .disposed(by: disposeBag)
    }
}

extension RoadViewController: SearchViewDelegate {
    func dismissSearchView() {
        locationInputView.alpha = 1
        placeholderLabel.alpha = 1
        searchView.alpha = 0
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func currentLocation() -> CLLocationCoordinate2D? {
        return position
    }
}
