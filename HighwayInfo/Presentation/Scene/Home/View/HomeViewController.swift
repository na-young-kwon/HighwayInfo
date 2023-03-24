//
//  ViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa
import AVKit

class HomeViewController: UIViewController {
    
    private enum Section {
        case accident
    }
    
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private var player: AVPlayer!
    private var avpController = AVPlayerViewController()
    private var dataSource: UITableViewDiffableDataSource<Section, AccidentViewModel>!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        configureDataSource()
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
    
    private func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, AccidentViewModel>(tableView: tableView) { (tableView: UITableView, indexPath: IndexPath, viewModel: AccidentViewModel) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccidentCell.reuseID, for: indexPath) as? AccidentCell else {
                return UITableViewCell()
            }
            cell.bind(viewModel)
            cell.imageViewTap.subscribe(onNext: { _ in
                self.presentVideo(for: viewModel.video)
            })
            .disposed(by: self.disposeBag)
            return cell
        }
    }
    
    private func updateUI(with viewModel: [AccidentViewModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AccidentViewModel>()
        snapShot.appendSections([.accident])
        snapShot.appendItems(viewModel)
        dataSource.apply(snapShot)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let imageViewTap = PublishRelay<(Double, Double)>()

        let input = HomeViewModel.Input(trigger: viewWillAppear,
                                        refreshButtonTapped: refreshButton.rx.tap.asObservable(),
                                        imageViewTapped: imageViewTap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.accidents
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { accidents in
            self.updateUI(with: accidents)
        })
        .disposed(by: self.disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func presentVideo(for url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else {
            return
        }
        player = AVPlayer(url: url)
        avpController.player = player
        present(avpController, animated: true)
        player.play()
    }
}
