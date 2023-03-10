//
//  ViewController.swift
//  HighwayInfo
//
//  Created by κΆλμ on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa

enum Road {
    case accident, construction
}

class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var itemSelected = BehaviorSubject<Road>(value: .accident)
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var toggleBackground: UIView!
    @IBOutlet weak var toggleForeground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accidentButton: UIButton!
    @IBOutlet weak var constructionButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        bindViewModel()
    }
    
    private func configureUI() {
        whiteView.layer.cornerRadius = 15
        toggleBackground.layer.cornerRadius = 10
        toggleForeground.layer.cornerRadius = 10
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
        
        let selectedRelay = BehaviorRelay<Road>(value: .accident)
        
        accidentButton.rx.tap.asObservable()
            .subscribe(onNext: {
                selectedRelay.accept(.accident)
                UIView.animate(withDuration: 0.2) {
                    self.toggleForeground.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            })
            .disposed(by: disposeBag)
        
        constructionButton.rx.tap.asObservable()
            .subscribe(onNext: {
                selectedRelay.accept(.construction)
                UIView.animate(withDuration: 0.2) {
                    self.toggleForeground.transform = CGAffineTransform(translationX: 175, y: 0)
                }
            })
            .disposed(by: disposeBag)

        let input = HomeViewModel.Input(trigger: viewWillAppear,
                                        selectedRoad: selectedRelay,
                                        refreshButtonTapped: refreshButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.accidents.bind(to: tableView.rx.items(
            cellIdentifier: AccidentCell.reuseID.self,
            cellType: AccidentCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
