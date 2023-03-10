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
    private let itemSelected = BehaviorSubject<Road>(value: .accident)
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
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        // 로직 개선
        accidentButton.rx.tap.bind { [weak self] _ in
            self?.itemSelected.onNext(.accident)
            UIView.animate(withDuration: 0.2) {
                self?.toggleForeground.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
        .disposed(by: disposeBag)
        
        constructionButton.rx.tap.bind { [weak self] _ in
            self?.itemSelected.onNext(.construction)
            UIView.animate(withDuration: 0.2) {
                self?.toggleForeground.transform = CGAffineTransform(translationX: 175, y: 0)
            }
        }
        .disposed(by: disposeBag)
        
        let selectedRoad = itemSelected.asDriver(onErrorJustReturn: .accident)
        let input = HomeViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                        selectedRoad: selectedRoad)
        
//        let input = HomeViewModel.Input(trigger: viewWillAppear.asDriver())
        let output = viewModel.transform(input: input)
        
        output.accidents.drive(tableView.rx.items(
            cellIdentifier: AccidentCell.reuseID.self,
            cellType: AccidentCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshButton.rx.tap
            .bind {
                print("새로고침 버튼 눌림")
            }
            .disposed(by: disposeBag)
    }
}
