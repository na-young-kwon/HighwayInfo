//
//  ViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/02.
//

import UIKit
import SnapKit
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
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "HighwayInfo"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "돌발정보"
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private var whiteView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    private var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("새로고침", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AccidentCell.self, forCellReuseIdentifier: AccidentCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
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
        view.backgroundColor = .mainBlueColor
        configureHierarchy()
        configureConstraint()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureHierarchy() {
        view.addSubview(whiteView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(refreshButton)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
    }
        
    private func configureConstraint() {
        loadingIndicator.center = view.center
        whiteView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.85)
            make.leading.trailing.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalTo(whiteView.snp.top).inset(-25)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(whiteView).inset(18)
        }
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(whiteView).inset(14)
            make.trailing.equalToSuperview().inset(14)
        }
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(descriptionLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.trailing.equalTo(whiteView).inset(18)
            make.bottom.equalTo(whiteView)
        }
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
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let input = HomeViewModel.Input(viewWillAppear: viewWillAppear,
                                        refreshButtonTapped: refreshButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.accidents
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { accidents in
                self.applySnapshot(with: accidents)
            })
            .disposed(by: self.disposeBag)
        
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
