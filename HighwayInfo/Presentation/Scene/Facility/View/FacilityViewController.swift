//
//  FacilityViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/08.
//

import UIKit
import RxSwift
import RxCocoa

final class FacilityViewController: UIViewController {
    enum CategorySection: Int, CaseIterable {
        case main
    }
    enum FacilitySection: Int, CaseIterable {
        case main
    }
    @IBOutlet weak var titleLabel: UILabel!
    var viewModel: FacilityViewModel!
    private let disposeBag = DisposeBag()
    private var categoryCollectionView: UICollectionView!
    private var facilityCollectionView: UICollectionView!
    private var categoryDataSource: UICollectionViewDiffableDataSource<CategorySection, Facility>!
    private var facilityDataSource: UICollectionViewDiffableDataSource<FacilitySection, AnyHashable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureCollectionView() {
        categoryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCategoryLayout())
        categoryCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(categoryCollectionView)
        categoryCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.27).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18).isActive = true
        categoryCollectionView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10)
        facilityCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createFacilityLayout())
        facilityCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(facilityCollectionView)
        facilityCollectionView.backgroundColor = .systemGray6
        facilityCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        facilityCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        facilityCollectionView.anchor(top: titleLabel.bottomAnchor, left: categoryCollectionView.rightAnchor, paddingTop: 15, paddingLeft: 0)
    }
    
    private func createCategoryLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createFacilityLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        let facilityCellRegistration = UICollectionView.CellRegistration<FacilityCell, Facility> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        let foodMenuRegistration = UICollectionView.CellRegistration<FoodMenuCell, FoodMenu> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        categoryDataSource = UICollectionViewDiffableDataSource<CategorySection, Facility>(collectionView: categoryCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Facility) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: facilityCellRegistration, for: indexPath, item: item)
        }
        facilityDataSource = UICollectionViewDiffableDataSource<FacilitySection, AnyHashable>(collectionView: facilityCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            if let foodMenu = item as? FoodMenu {
                return collectionView.dequeueConfiguredReusableCell(using: foodMenuRegistration, for: indexPath, item: foodMenu)
            }
            return nil
        }
        var snapshot = NSDiffableDataSourceSnapshot<CategorySection, Facility>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Facility.allCases)
        categoryDataSource.apply(snapshot)
        categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .bottom)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let input = FacilityViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        titleLabel.text = output.serviceAreaName
        
        output.foodMenuList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { foodMenu in
                var snapshot = NSDiffableDataSourceSnapshot<FacilitySection, AnyHashable>()
                snapshot.appendSections([.main])
                snapshot.appendItems(foodMenu)
                self.facilityDataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        viewModel.removeFromSuperview()
    }
}
