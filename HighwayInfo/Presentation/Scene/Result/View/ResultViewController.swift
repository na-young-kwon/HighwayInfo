//
//  ResultViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit
import RxSwift
import RxCocoa
import TMapSDK
import CoreLocation

class ResultViewController: UIViewController, TMapViewDelegate {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    private var mapView: TMapView?
    private let apiKey = "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
    }

    private func configureMapView() {
        mapView = TMapView(frame: backgroundView.frame)
        mapView?.delegate = self
        mapView?.setApiKey(apiKey)
        backgroundView.addSubview(mapView!)
    }
}


