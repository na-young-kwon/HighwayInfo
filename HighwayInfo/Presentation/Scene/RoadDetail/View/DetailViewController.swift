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
    @IBOutlet weak var reverseButton: UIButton!
    
    var viewModel: RoadDetailViewModel!
    private let disposeBag = DisposeBag()
    private var dataSource: UITableViewDiffableDataSource<Section, RoadDetail>!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
        configureDataSource()
        configureToggleAnimation()
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
    
    private func configureToggleAnimation() {
        upButton.rx.tap.bind { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.toggleForeground.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
        .disposed(by: disposeBag)
        
        reverseButton.rx.tap.bind { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.toggleForeground.transform = CGAffineTransform(translationX: 175, y: 0)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func configureUI(with route: Route) {
        titleLabel.text = route.name + "고속도로"
        upButton.titleLabel?.font = .systemFont(ofSize: 13)
        upButton.setTitle(route.upString, for: .normal)
        upButton.setTitleColor(UIColor(named: "MainBlue"), for: .normal)
        reverseButton.titleLabel?.font = .systemFont(ofSize: 13)
        reverseButton.setTitle(route.downString, for: .normal)
        reverseButton.setTitleColor(UIColor(named: "MainBlue"), for: .normal)
        imageView.image = UIImage(named: route.number)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        
        let input = RoadDetailViewModel.Input(viewWillAppear: viewWillAppear,
                                              upButtonTap: upButton.rx.tap.asObservable(),
                                              reverseButtonTap: reverseButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        configureUI(with: output.route)
        
        output.roads
            .drive(onNext: { roadDetails in
                self.applySnapshot(with: roadDetails)
            })
            .disposed(by: disposeBag)
    }
}
