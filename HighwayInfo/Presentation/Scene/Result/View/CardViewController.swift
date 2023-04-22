//
//  DetailViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit

class CardViewController: UIViewController {
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var roadImageView: UIImageView!
    @IBOutlet weak var roadName: UILabel!
    @IBOutlet weak var convenienceCollectionView: UICollectionView!
    @IBOutlet weak var petrolCollectionView: UICollectionView!
    @IBOutlet weak var convenienceButton: UIButton!
    @IBOutlet weak var petrolButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        handleArea.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.6
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
