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
import WebKit

class RoadViewController: UIViewController, TMapViewDelegate {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var locationInputView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var viewModel: RoadViewModel!
    private let disposeBag = DisposeBag()
    private var webView: WKWebView?
    
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
    }
    
    private func configureMapView() {
        webView = WKWebView(frame: backgroundView.frame)
        let url = URL(string: "https://velog.io/@na-young-kwon")
        let request = URLRequest(url: url!)
        webView?.allowsBackForwardNavigationGestures = true 
        webView?.load(request)
        backgroundView.addSubview(webView!)
    }
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showSearchView))
        locationInputView.addGestureRecognizer(tap)
    }
    
    private func bindViewModel() {
        let viewDidLoad = Observable.of(Void())
        let input = RoadViewModel.Input(viewDidLoad: viewDidLoad)
        let output = viewModel.transform(input: input)
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
    
    @objc func showSearchView() {
        viewModel.showSearchView()
    }
}
