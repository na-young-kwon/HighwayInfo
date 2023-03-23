//
//  ViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit

class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
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
        
        let imageViewtap = PublishRelay<(Double, Double)>()

        let input = HomeViewModel.Input(trigger: viewWillAppear,
                                        refreshButtonTapped: refreshButton.rx.tap.asObservable(),
                                        imageViewTapped: imageViewtap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.accidents.bind(to: tableView.rx.items(
            cellIdentifier: AccidentCell.reuseID.self,
            cellType: AccidentCell.self)) { _, viewModel, cell in
                cell.bind(viewModel.0, url: viewModel.1)
                cell.imageViewTap.subscribe { _ in
                    let coordinate = (viewModel.0.coordx, viewModel.0.coordy)
                    imageViewtap.accept(coordinate)
                    output.videoURL
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { url in
                            if url != nil {
                                self.presentVideo(for: url)
                            }
                        })
                        .disposed(by: self.disposeBag)
                }
                .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func presentVideo(for url: String?) {
        let window = UIApplication.shared.windows.last!
        let backgroundView = UIView(frame: window.bounds)
        let superView = view.frame
        window.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        guard let urlString = url,
                let url = URL(string: urlString) else {
            return
            
        }
        player = AVPlayer(url: url)
        avpController.player = player
        avpController.view.frame = CGRect(x: 0,
                                          y: 600,
                                          width: superView.width,
                                          height: superView.height * 0.3)
        backgroundView.addSubview(avpController.view)
        player.play()
    }
}
