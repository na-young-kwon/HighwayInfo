//
//  RoadViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit
import RxSwift
import RxCocoa

class RoadViewController: UIViewController {
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    private let disposeBag = DisposeBag()
    var viewModel: RoadViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    private func configureUI() {
        textField.clearButtonMode = .always
        whiteView.layer.cornerRadius = 15
    }
}
