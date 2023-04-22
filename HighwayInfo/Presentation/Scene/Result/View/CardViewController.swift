//
//  DetailViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit
import RxSwift
import RxCocoa

class CardViewController: UIViewController {
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var roadImageView: UIImageView!
    @IBOutlet weak var roadName: UILabel!
    @IBOutlet weak var convenienceCollectionView: UICollectionView!
    @IBOutlet weak var petrolCollectionView: UICollectionView!
    @IBOutlet weak var convenienceButton: UIButton!
    @IBOutlet weak var petrolButton: UIButton!
    
    var viewModel: CardViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        handleArea.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.6
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func bindViewModel() {
        let input = CardViewModel.Input()
        let output = viewModel.transform(input: input)
        output.emptyHighway
            .subscribe(onNext: { isEmpty in
                if isEmpty {
                    self.view = EmptyView()
                    self.configureUI()
                } else {
                    print("fetch result")
                }
            })
            .disposed(by: disposeBag)
    }
}
