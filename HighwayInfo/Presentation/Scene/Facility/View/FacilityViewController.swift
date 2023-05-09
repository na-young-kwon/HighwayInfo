//
//  FacilityViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/08.
//

import UIKit

class FacilityViewController: UIViewController {
    var viewModel: FacilityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let input = FacilityViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
    }
}
