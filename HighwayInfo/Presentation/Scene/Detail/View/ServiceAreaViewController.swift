//
//  ServiceAreaViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/04.
//

import UIKit
import RxSwift
import RxCocoa

class ServiceAreaViewController: UIViewController {
    enum TitleSection: CaseIterable {
        case main
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ServiceAreaViewModel!
    private let disposeBag = DisposeBag()
    private var titleDataSource: UICollectionViewDiffableDataSource<TitleSection, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let input = ServiceAreaViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.serviceArea
            .subscribe(onNext: { area in
                print(area)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { index in
                let selectedCategory = self.titleDataSource.itemIdentifier(for: index)
                print(selectedCategory)
            })
            .disposed(by: disposeBag)
    }
}
