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
        case serviceArea, gasStation
        
        var description: String {
            switch self {
            case .serviceArea:
                return "휴게시설"
            case .gasStation:
                return "주유소"
            }
        }
    }
    
    enum Item: Hashable {
        case serviceArea(ServiceArea), gasStation(GasStation)
    }
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var titleCollectionView: UICollectionView!
    
    private let titleElementKind = "title-element-kind"
    var viewModel: CardViewModel!
    private let disposeBag = DisposeBag()
    private var detailCollectionView: UICollectionView!
    private var titleDataSource: UICollectionViewDiffableDataSource<String, HighwayInfo>!
    private var detailDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
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
        detailCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .systemBackground
        view.addSubview(detailCollectionView)
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
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: self.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func configureDataSource() {
        let highwayCellRegistration = UICollectionView.CellRegistration<HighwayCell, HighwayInfo> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        let serviceCellRegistration = UICollectionView.CellRegistration<ServiceCell, ServiceArea> { (cell, indexPath, item) in
            cell.bindViewModel(with: item)
        }
        let gasCellRegistration = UICollectionView.CellRegistration<GasStationCell, GasStation> { (cell, indexPath, item) in
            cell.bindViewModel(with: item)
        }
        
        detailDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: detailCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            var value: Any
            switch item {
            case .serviceArea(let item):
                value = item
            case .gasStation(let item):
                value = item
            }
            
            switch Section(rawValue: indexPath.section) {
            case .serviceArea:
                return collectionView.dequeueConfiguredReusableCell(using: serviceCellRegistration, for: indexPath, item: value as? ServiceArea)
            case .gasStation:
                return collectionView.dequeueConfiguredReusableCell(using: gasCellRegistration, for: indexPath, item: value as? GasStation)
            case .none:
                return UICollectionViewCell()
            }
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleView>(elementKind: titleElementKind) {
            (titleView, string, indexPath) in
            let section = self.detailDataSource.snapshot().sectionIdentifiers[indexPath.section]
            titleView.label.text = section.description
        }
        
        detailDataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.detailCollectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
    }
    
    private func bindViewModel() {
        let input = CardViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.highway
            .subscribe(onNext: { highway in
                if highway == [] {
                    self.view = EmptyView()
                } else {
                    print("fetch result")
                }
            })
            .disposed(by: disposeBag)
    }
}
