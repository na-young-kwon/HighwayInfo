//
//  ServiceAreaViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ServiceAreaViewController: UIViewController {
    enum TitleSection: CaseIterable {
        case main
    }
    @IBOutlet weak var titleLabel: UILabel!
    var viewModel: ServiceAreaViewModel!
    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private var titleDataSource: UICollectionViewDiffableDataSource<TitleSection, Convenience>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTitleLayout())
        collectionView.alwaysBounceVertical = false
        view.addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10)
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    private func createTitleLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        let convenienceCellRegistration = UICollectionView.CellRegistration<ConvenienceCell, Convenience> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        titleDataSource = UICollectionViewDiffableDataSource<TitleSection, Convenience>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Convenience) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: convenienceCellRegistration, for: indexPath, item: item)
        }
        var snapshot = NSDiffableDataSourceSnapshot<TitleSection, Convenience>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Convenience.allCases)
        titleDataSource.apply(snapshot, animatingDifferences: false)
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let input = ServiceAreaViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.highwayName
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
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
