//
//  DetailViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit
import RxSwift
import RxCocoa

class CardViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case highway, serviceArea, gasStation
    }
    
    enum Item: Int, CaseIterable {
        case highway, serviceArea, gasStation
    }
    
    @IBOutlet weak var handleArea: UIView!
    
    var viewModel: CardViewModel!
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureHierarchy()
        bindViewModel()
        configureDataSource()
    }
    
    private func configureUI() {
        handleArea.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.6
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                  heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
//            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: titleSize,
//                elementKind: ConferenceVideoSessionsViewController.titleElementKind,
//                alignment: .top)
//            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func configureDataSource() {
        let highwayCellRegistration = UICollectionView.CellRegistration<HighwayCell, Item> { (cell, indexPath, identifier) in
        }
        let serviceCellRegistration = UICollectionView.CellRegistration<ServiceCell, Item> { (cell, indexPath, identifier) in
        }
        let gasCellRegistration = UICollectionView.CellRegistration<ServiceCell, Item> { (cell, indexPath, identifier) in
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            switch Section(rawValue: indexPath.section) {
            case .highway:
                return collectionView.dequeueConfiguredReusableCell(using: highwayCellRegistration, for: indexPath, item: item)
            case .serviceArea:
                return collectionView.dequeueConfiguredReusableCell(using: serviceCellRegistration, for: indexPath, item: item)
            case .gasStation:
                return collectionView.dequeueConfiguredReusableCell(using: gasCellRegistration, for: indexPath, item: item)
            case .none:
                return collectionView.dequeueConfiguredReusableCell(using: highwayCellRegistration, for: indexPath, item: item)
            }
        }
    }
    
    private func bindViewModel() {
        let input = CardViewModel.Input()
        let output = viewModel.transform(input: input)
        output.highway
            .subscribe(onNext: { highway in
                if highway == nil {
                    self.view = EmptyView()
                } else {
                    print("fetch result")
                }
            })
            .disposed(by: disposeBag)
    }
}
