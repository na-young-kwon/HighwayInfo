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

class RoadViewController: UIViewController, TMapViewDelegate {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var locationInputView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    private let searchView = SearchView()
    private var mapView: TMapView?
    private let apiKey = "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    private let disposeBag = DisposeBag()
    var viewModel: RoadViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMapView()
        configureTapGesture()
    }
    
    private func configureUI() {
        locationInputView.layer.cornerRadius = locationInputView.frame.size.height / 2
        locationInputView.layer.borderColor = UIColor.white.cgColor
        locationInputView.layer.borderWidth = 0.25
        locationInputView.backgroundColor = .white
        locationInputView.layer.shadowOpacity = 1
        locationInputView.layer.shadowRadius = 3.0
        locationInputView.layer.shadowOffset = CGSize.zero
        locationInputView.layer.shadowColor = UIColor.gray.cgColor
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
        searchView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height)
        
        UIView.animate(withDuration: 0.5) {
            self.searchView.alpha = 1
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSearchView))
        locationInputView.addGestureRecognizer(tap)
    }
    
    @objc func showSearchView() {
        locationInputView.alpha = 0
        placeholderLabel.alpha = 0
        configureSearchView()
    }
}


extension RoadViewController: SearchViewDelegate {
    func dismissSearchView() {
        locationInputView.alpha = 1
        placeholderLabel.alpha = 1
        searchView.alpha = 0
        self.tabBarController?.tabBar.isHidden = false
    }
}
