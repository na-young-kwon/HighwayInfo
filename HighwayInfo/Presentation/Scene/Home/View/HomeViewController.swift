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
import Lottie

class HomeViewController: UIViewController {
    
    private enum Section {
        case accident
    }
    
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private var videoPlayer: AVPlayer!
    private var videoController = AVPlayerViewController()
    private var dataSource: UITableViewDiffableDataSource<Section, AccidentViewModel>!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var loadingIndicator: LottieAnimationView = {
        let animation = LottieAnimation.named("GrayLoadingIndicator")
        let view = LottieAnimationView(animation: animation)
        view.loopMode = .loop
        view.play { finished in
            view.removeFromSuperview()
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureUI() {
        whiteView.layer.cornerRadius = 15
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
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
            self.loadingIndicator.stop()
            cell.imageViewTap.subscribe(onNext: { _ in
                self.presentVideo(for: viewModel.video)
            })
            .disposed(by: self.disposeBag)
            return cell
        }
        dataSource.defaultRowAnimation = .top
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
        
        output.accidents
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { accidents in
                self.applySnapshot(with: accidents)
            })
            .disposed(by: self.disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshButton.rx.tap
            .bind { _ in
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteAllItems()
                self.dataSource.apply(snapshot)
                self.view.addSubview(self.loadingIndicator)
                self.loadingIndicator.play { finished in
                    self.loadingIndicator.removeFromSuperview()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot(with viewModel: [AccidentViewModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AccidentViewModel>()
        snapShot.appendSections([.accident])
        snapShot.appendItems(viewModel)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func presentVideo(for url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else {
            return
        }
        videoPlayer = AVPlayer(url: url)
        videoController.player = videoPlayer
        present(videoController, animated: true)
        videoPlayer.play()
    }
}
