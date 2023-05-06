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
    enum Section: Int, CaseIterable {
        case title
        case list
    }
    @IBOutlet weak var titleLabel: UILabel!
    var viewModel: ServiceAreaViewModel!
    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTitleLayout())
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor ,right: view.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
    private func createTitleLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            if sectionKind == .title {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.22))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
            } else if sectionKind == .list {
                var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                configuration.showsSeparators = false
                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            } else {
                fatalError("Unknown section")
            }
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
    
    private func configureDataSource() {
        let convenienceCellRegistration = UICollectionView.CellRegistration<ConvenienceCell, Convenience> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        let serviceListCell = UICollectionView.CellRegistration<ServiceListCell, ServiceArea> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            if let convenience = item as? Convenience {
                return collectionView.dequeueConfiguredReusableCell(using: convenienceCellRegistration, for: indexPath, item: convenience)
            } else if let serviceArea = item as? ServiceArea {
                return collectionView.dequeueConfiguredReusableCell(using: serviceListCell, for: indexPath, item: serviceArea)
            }
            return nil
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.title])
        snapshot.appendItems(Convenience.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
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
            .subscribe(onNext: { serviceArea in
                var snapshot = self.dataSource.snapshot()
                snapshot.appendSections([.list])
                snapshot.appendItems(serviceArea)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { index in
                let selectedCategory = self.dataSource.itemIdentifier(for: index)
                print(selectedCategory)
            })
            .disposed(by: disposeBag)
    }
}
