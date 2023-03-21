//
//  ViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa

enum Road {
    case accident, construction
}

class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        bindViewModel()
    }
    
    private func configureUI() {
        whiteView.layer.cornerRadius = 15
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: AccidentCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AccidentCell.reuseID)
        tableView.refreshControl = UIRefreshControl()
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        let input = HomeViewModel.Input(trigger: viewWillAppear,
                                        refreshButtonTapped: refreshButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.accidents.bind(to: tableView.rx.items(
            cellIdentifier: AccidentCell.reuseID.self,
            cellType: AccidentCell.self)) { _, viewModel, cell in
                cell.bind(viewModel.0, url: viewModel.1)
            }.disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
