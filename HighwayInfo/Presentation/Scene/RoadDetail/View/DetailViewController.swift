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
    private enum Section {
        case road
    }
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var toggleBackground: UIView!
    @IBOutlet weak var toggleForeground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    var viewModel: RoadDetailViewModel!
    private let disposeBag = DisposeBag()
    private var dataSource: UITableViewDiffableDataSource<Section, RoadDetail>!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
        configureDataSource()
        bindViewModel()
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
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: RoadDetailCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RoadDetailCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, RoadDetail>(tableView: tableView) { (tableView: UITableView, indexPath: IndexPath, viewModel: RoadDetail) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoadDetailCell.reuseID, for: indexPath) as? RoadDetailCell else {
                return UITableViewCell()
            }
            cell.bind(with: viewModel)
            return cell
        }
    }
    
    private func applySnapshot(with viewModel: [RoadDetail]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, RoadDetail>()
        snapShot.appendSections([.road])
        snapShot.appendItems(viewModel)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
        
        let input = RoadDetailViewModel.Input(trigger: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.roads
            .drive(onNext: { details in
                self.applySnapshot(with: details)
            })
            .disposed(by: disposeBag)
        
        titleLabel.text = output.route.name
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
