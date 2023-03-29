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
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: RoadViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
        bindViewModel()
    }

    private func configureUI() {
        tableView.layer.cornerRadius = 15
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: RoadCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RoadCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func bindViewModel() {
        let selectedRoute = tableView.rx.itemSelected.asDriver()
        let input = RoadViewModel.Input(selectedRoute: selectedRoute)
        let output = viewModel.transform(input: input)
        
        output.routes.bind(to: tableView.rx.items(
            cellIdentifier: RoadCell.reuseID, cellType: RoadCell.self)) { _, route, cell in
                cell.bindCell(with: route)
            }
            .disposed(by: disposeBag)
    }
}
