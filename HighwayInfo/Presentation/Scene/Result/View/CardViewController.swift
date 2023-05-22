//
//  DetailViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/10.
//

import UIKit
import RxSwift
import RxCocoa

final class CardViewController: UIViewController {
    enum TitleSection: CaseIterable {
        case main
    }
    enum DetailSection: Int, CaseIterable {
        case serviceArea, gasStation
        
        var description: String {
            switch self {
            case .serviceArea:
                return "휴게소"
            case .gasStation:
                return "주유소"
            }
        }
    }
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var titleCollectionView: UICollectionView!
    weak var viewModel: CardViewModel!
    private let titleElementKind = "title-element-kind"
    private let disposeBag = DisposeBag()
    private var detailCollectionView: UICollectionView!
    private var titleDataSource: UICollectionViewDiffableDataSource<TitleSection, HighwayInfo>!
    private var detailDataSource: UICollectionViewDiffableDataSource<DetailSection, AnyHashable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureHierarchy()
        configureDataSource()
        bindViewModel()
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
        titleCollectionView.collectionViewLayout = createTitleLayout()
        detailCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createDetailLayout())
        detailCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleCollectionView.alwaysBounceVertical = false
        detailCollectionView.alwaysBounceVertical = false
        view.addSubview(detailCollectionView)
        detailCollectionView.anchor(top: titleCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                                    paddingTop: 20, paddingLeft: 15, paddingBottom: 30, paddingRight: 15)
    }
    
    private func createTitleLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(30), heightDimension: .fractionalHeight(1.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createDetailLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let widthDimension: NSCollectionLayoutDimension = .fractionalWidth(0.5)
            let heightDimension: NSCollectionLayoutDimension = .fractionalHeight(0.25)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20)
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.15),
                                                   heightDimension: .fractionalWidth(0.2))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: "title-element-kind",
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
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
        titleDataSource = UICollectionViewDiffableDataSource<TitleSection, HighwayInfo>(collectionView: titleCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: HighwayInfo) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: highwayCellRegistration, for: indexPath, item: item)
        }
        detailDataSource = UICollectionViewDiffableDataSource<DetailSection, AnyHashable>(collectionView: detailCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            if let service = item as? ServiceArea {
                return collectionView.dequeueConfiguredReusableCell(using: serviceCellRegistration, for: indexPath, item: service)
            } else if let gas = item as? GasStation {
                return collectionView.dequeueConfiguredReusableCell(using: gasCellRegistration, for: indexPath, item: gas)
            }
            return nil
        }
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: titleElementKind) {
            [weak self] (titleView, string, indexPath) in
            guard let section = self?.detailDataSource.snapshot().sectionIdentifiers[indexPath.section] else {
                return
            }
            if section == .gasStation { titleView.hideShowMoreButton() }
            titleView.setTitle(with: section.description)
            titleView.moreButtonTapped
                .subscribe(onNext: { [weak self] _ in
                    self?.viewModel.showServiceDetail()
                })
                .disposed(by: self!.disposeBag)
        }
        detailDataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.detailCollectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
    }
    
    private func bindViewModel() {
        let selectedHighway = PublishSubject<HighwayInfo?>()
        let selectedServiceArea = PublishSubject<ServiceArea>()
        let input = CardViewModel.Input(selectedHighway: selectedHighway.asObservable(),
                                        selectedServiceArea: selectedServiceArea.asObservable())
        let output = viewModel.transform(input: input)
                
        titleCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                let highway = self?.titleDataSource.itemIdentifier(for: index)
                selectedHighway.onNext(highway)
            })
            .disposed(by: disposeBag)
        
        detailCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let serviceArea = self?.detailDataSource.itemIdentifier(for: index) as? ServiceArea else {
                    return
                }
                selectedServiceArea.onNext(serviceArea)
            })
            .disposed(by: disposeBag)
        
        output.highway
            .drive(onNext: { [weak self] highway in
                if highway == [] {
                    let emptyView = EmptyView()
                    self?.view = emptyView
                    emptyView.backButtonTapped
                        .subscribe(onNext: { _ in
                            self?.viewModel.popViewController()
                        })
                        .disposed(by: self!.disposeBag)
                } else {
                    self?.applySnapshot(with: highway)
                    self?.selectFirstItem()
                }
            })
            .disposed(by: disposeBag)
        
        output.result
            .drive(onNext: { [weak self] result in
                self?.applySnapshot(for: result)
            })
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot(with highwayInfo: [HighwayInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<TitleSection, HighwayInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(highwayInfo)
        titleDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySnapshot(for result: ([ServiceArea], [GasStation])) {
        if result.0.isEmpty {
            detailCollectionView.backgroundView = EmptyServiceAreaView()
            var snapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>()
            snapshot.appendSections([.serviceArea])
            detailDataSource.apply(snapshot, animatingDifferences: false)
        } else {
            detailCollectionView.backgroundView = nil
            var snapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>()
            snapshot.appendSections([.serviceArea, .gasStation])
            snapshot.appendItems(result.0, toSection: .serviceArea)
            snapshot.appendItems(result.1, toSection: .gasStation)
            detailDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func selectFirstItem() {
        let firstItem = IndexPath(item: 0, section: 0)
        titleCollectionView.selectItem(at: firstItem, animated: false, scrollPosition: .left)
    }
}
