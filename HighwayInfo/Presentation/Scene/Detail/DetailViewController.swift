//
//  DetailViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/04.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var toggleBackground: UIView!
    @IBOutlet weak var toggleForeground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: RoadDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func configureUI() {
        whiteView.layer.cornerRadius = 15
        toggleBackground.layer.cornerRadius = 10
        toggleForeground.layer.cornerRadius = 10
        titleLabel.text = viewModel.route.name + "고속도로"
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.toggleForeground.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @IBAction func reverseButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.toggleForeground.transform = CGAffineTransform(translationX: 175, y: 0)
        }
    }
}
