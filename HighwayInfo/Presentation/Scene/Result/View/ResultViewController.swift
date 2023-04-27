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
    
    private enum CardState {
        case collapsed
        case expanded
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    
    var viewModel: ResultViewModel!
    private var cardViewController: CardViewController!
    private var mapView: TMapView?
    private let apiKey = "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    private let disposeBag = DisposeBag()
    private var markers: Array<TMapMarker> = []
    // CardView
    private var startCardHeight: CGFloat = 0
    private var endCardHeight: CGFloat = 0
    private var cardVisible = false
    private var runningAnimations: [UIViewPropertyAnimator] = []
    private var animationProgressWhenInterrupted: CGFloat = 0
    private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureCardView()
        bindViewModel()
    }
    
    private func configureMapView() {
        mapView = TMapView(frame: backgroundView.frame)
        mapView?.delegate = self
        mapView?.setApiKey(apiKey)
        backgroundView.addSubview(mapView!)
    }
    
    private func configureCardView() {
        startCardHeight = self.view.frame.height * 0.3
        endCardHeight = self.view.frame.height * 0.85
        cardViewController = CardViewController(nibName: CardViewController.reuseID, bundle: nil)
        cardViewController.viewModel = viewModel.cardViewModel
        self.view.addSubview(cardViewController.view)
        self.cardViewController.view.layer.cornerRadius = 30
        cardViewController.view.frame = CGRect(x: 0,
                                               y: self.view.frame.height - startCardHeight,
                                               width: self.view.bounds.width,
                                               height: endCardHeight)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handleCardPan(recognizer:)))
        cardViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let input = ResultViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        bindingOutput(for: output)
    }
    
    private func bindingOutput(for output: ResultViewModel.Output) {
        output.startPointName
            .drive(startPointLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.endPointName
            .drive(endPointLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.markerPoint
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (startPoint, endPoint) in
                let startMarker = TMapMarker(position: startPoint)
                let endMarker = TMapMarker(position: endPoint)
                endMarker.map = self.mapView
                startMarker.map = self.mapView
                self.fitMapBoundsWithRectangles(startPoint: startPoint, endPoint: endPoint)
            })
            .disposed(by: disposeBag)
        
        output.path
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { path in
                let polyLine = TMapPolyline(coordinates: path)
                polyLine.strokeWidth = 6
                polyLine.strokeColor = UIColor(named: "MainBlue")
                polyLine.map = self.mapView
            })
            .disposed(by: disposeBag)
        
        output.highwayInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { info in
                self.showCustomMarker(with: info)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        viewModel.removeCoordinator()
    }
}

extension ResultViewController {
    private func showCustomMarker(with info: [HighwayInfo]) {
        info.forEach { info in
            let marker = TMapCustomMarker(position: info.coordinate)
            marker.offset = CGSize(width: 0, height: 0)
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
            view.layer.cornerRadius = 10
            view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            let label = UILabel(frame: CGRect(x: 5, y: 5, width: 90, height: 20))
            label.text = info.name
            label.textColor = .white
            label.font = .systemFont(ofSize: 13)
            view.addSubview(label)
            label.centerX(inView: view)
            label.centerY(inView: view)
            
            marker.view = view
            marker.map = self.mapView
        }
    }
    
    private func fitMapBoundsWithRectangles(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) {
        let ne = CLLocationCoordinate2D(latitude: endPoint.latitude - 0.3, longitude: endPoint.longitude + 0.3)
        let sw = CLLocationCoordinate2D(latitude: startPoint.latitude + 0.3, longitude: startPoint.longitude - 0.3)
        let rectangle = TMapRectangle(rectangle: MapBounds(sw: sw, ne: ne))
        rectangle.fillColor = .clear
        rectangle.strokeColor = .clear
        rectangle.map = self.mapView
        self.mapView?.fitMapBoundsWithRectangles([rectangle])
    }
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
            
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / endCardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
            
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.endCardHeight
                    
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.startCardHeight
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                self.cardViewController.view.layer.cornerRadius = state == .expanded ? 0 : 30
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        }
    }
    
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
