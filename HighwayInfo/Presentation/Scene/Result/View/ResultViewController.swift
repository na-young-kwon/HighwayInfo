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
    
    enum CardState {
        case collapsed
        case expanded
    }
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    private var cardViewController:CardViewController!
    private var mapView: TMapView?
    private let apiKey = "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"
    private let disposeBag = DisposeBag()
    
    private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    private var startCardHeight: CGFloat = 0
    private var endCardHeight: CGFloat = 0
    private var cardVisible = false
    
    private var runningAnimations: [UIViewPropertyAnimator] = []
    private var animationProgressWhenInterrupted: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        setupCard()
    }
    
    private func configureMapView() {
        mapView = TMapView(frame: backgroundView.frame)
        mapView?.delegate = self
        mapView?.setApiKey(apiKey)
        backgroundView.addSubview(mapView!)
    }
    
    private func setupCard() {
        startCardHeight = self.view.frame.height * 0.3
        endCardHeight = self.view.frame.height * 0.85
        
        cardViewController = CardViewController(nibName: CardViewController.reuseID, bundle: nil)
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
