//
//  ViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var toggleBackground: UIView!
    @IBOutlet weak var toggleForeground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accidentButton: UIButton!
    @IBOutlet weak var constructionButton: UIButton!
    
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
        
        let input = HomeViewModel.Input(trigger: Driver.merge(viewWillAppear, pull))
        let output = viewModel.transform(input: input)
        
        output.accidents.drive(tableView.rx.items(cellIdentifier: AccidentCell.reuseID.self, cellType: AccidentCell.self)) {
            tv, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    @IBAction func accidentButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.toggleForeground.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @IBAction func constructionButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.toggleForeground.transform = CGAffineTransform(translationX: 175, y: 0)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        print("새로고침 버튼 눌림")
    }
}
