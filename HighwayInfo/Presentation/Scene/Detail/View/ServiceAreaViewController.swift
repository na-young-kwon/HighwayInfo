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
    enum TitleSection: Int, CaseIterable {
        case main
    }
    enum FacilitySection: Int, CaseIterable {
        case main
    }
    @IBOutlet weak var titleLabel: UILabel!
    var viewModel: ServiceAreaViewModel!
    private var titleCollectionView: UICollectionView!
    private var facilityCollectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    private var titleDataSource: UICollectionViewDiffableDataSource<TitleSection, Convenience>!
    private var facilityDataSource: UICollectionViewDiffableDataSource<FacilitySection, ServiceArea>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureCollectionView() {
        titleCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTitleLayout())
        titleCollectionView.alwaysBounceVertical = false
        titleCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(titleCollectionView)
        titleCollectionView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10)
        titleCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        facilityCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        facilityCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(facilityCollectionView)
        facilityCollectionView.delegate = self
        facilityCollectionView.anchor(top: titleCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor ,right: view.rightAnchor,
                              paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
    }
    
    private func createTitleLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureDataSource() {
        let convenienceCellRegistration = UICollectionView.CellRegistration<ConvenienceCell, Convenience> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        let serviceListCell = UICollectionView.CellRegistration<ServiceListCell, ServiceArea> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        titleDataSource = UICollectionViewDiffableDataSource<TitleSection, Convenience>(collectionView: titleCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Convenience) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: convenienceCellRegistration, for: indexPath, item: item)
        }
        facilityDataSource = UICollectionViewDiffableDataSource<FacilitySection, ServiceArea>(collectionView: facilityCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ServiceArea) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: serviceListCell, for: indexPath, item: item)
        }
        var snapshot = NSDiffableDataSourceSnapshot<TitleSection, Convenience>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Convenience.allCases)
        titleDataSource.apply(snapshot, animatingDifferences: false)
        titleCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let selectedCategory = BehaviorSubject<Convenience>(value: .all)
        let selectedServiceArea = PublishSubject<ServiceArea>()
        let input = ServiceAreaViewModel.Input(viewWillAppear: viewWillAppear,
                                               selectedCategory: selectedCategory.asObservable(),
                                               selectedServiceArea: selectedServiceArea.asObservable())
        let output = viewModel.transform(input: input)
        
        output.highwayName
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.serviceArea
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] serviceArea in
                self?.applySnapShot(with: serviceArea)
            })
            .disposed(by: disposeBag)
        
        titleCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let convenience = self?.titleDataSource.itemIdentifier(for: index) else {
                    return
                }
                selectedCategory.onNext(convenience)
            })
            .disposed(by: disposeBag)
        
        facilityCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let serviceArea = self?.facilityDataSource.itemIdentifier(for: index) else {
                    return
                }
                selectedServiceArea.onNext(serviceArea)
            })
            .disposed(by: disposeBag)
    }
    
    private func applySnapShot(with service: [ServiceArea]) {
        var snapshot = NSDiffableDataSourceSnapshot<FacilitySection, ServiceArea>()
        snapshot.appendSections([.main])
        snapshot.appendItems(service)
        facilityDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    deinit {
        viewModel.removeFromSuperview()
    }
}

extension ServiceAreaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
