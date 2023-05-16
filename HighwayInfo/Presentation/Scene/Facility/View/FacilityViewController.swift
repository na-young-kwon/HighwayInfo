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
    @IBOutlet weak var addressLabel: UILabel!
    var viewModel: FacilityViewModel!
    private let disposeBag = DisposeBag()
    private var categoryCollectionView: UICollectionView!
    private var facilityCollectionView: UICollectionView!
    private var categoryDataSource: UICollectionViewDiffableDataSource<CategorySection, Facility>!
    private var facilityDataSource: UICollectionViewDiffableDataSource<FacilitySection, AnyHashable>!
    private let gasStationLabel = UILabel()
    private let telNoLabel = UILabel()
    private let telImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureUI() {
        view.addSubview(gasStationLabel)
        gasStationLabel.font = .systemFont(ofSize: 22, weight: .bold)
        gasStationLabel.anchor(top: facilityCollectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingRight: 15)
        view.addSubview(telImageView)
        telImageView.image = UIImage(systemName: "phone.fill")
        telImageView.tintColor = UIColor.blueGray_textColor
        telImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        telImageView.widthAnchor.constraint(equalTo: telImageView.heightAnchor).isActive = true
        telImageView.anchor(top: gasStationLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 18)
        view.addSubview(telNoLabel)
        telNoLabel.font = .systemFont(ofSize: 13)
        telNoLabel.textColor = UIColor.blueGray_textColor
        telNoLabel.anchor(top: gasStationLabel.bottomAnchor, left: telImageView.rightAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 15)
    }
    
    private func configureCollectionView() {
        categoryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCategoryLayout())
        categoryCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(categoryCollectionView)
        categoryCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.27).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18).isActive = true
        categoryCollectionView.anchor(top: addressLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10)
        facilityCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createFacilityLayout())
        facilityCollectionView.showsVerticalScrollIndicator = false
        facilityCollectionView.layer.cornerRadius = 15
        view.addSubview(facilityCollectionView)
        facilityCollectionView.backgroundColor = .systemGray6
        facilityCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        facilityCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        facilityCollectionView.anchor(top: addressLabel.bottomAnchor, left: categoryCollectionView.rightAnchor, paddingTop: 15, paddingLeft: 0)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        let facilityCellRegistration = UICollectionView.CellRegistration<FacilityCell, Facility> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        let foodCellRegistration = UICollectionView.CellRegistration<FoodMenuCell, FoodMenu> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        let convenienceCellRegistration = UICollectionView.CellRegistration<ConvenienceListCell, ConvenienceList> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        let brandCellRegistration = UICollectionView.CellRegistration<BrandListCell, Brand> { (cell, indexPath, data) in
            cell.bindViewModel(with: data)
        }
        categoryDataSource = UICollectionViewDiffableDataSource<CategorySection, Facility>(collectionView: categoryCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Facility) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: facilityCellRegistration, for: indexPath, item: item)
        }
        facilityDataSource = UICollectionViewDiffableDataSource<FacilitySection, AnyHashable>(collectionView: facilityCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable?) -> UICollectionViewCell? in
            if let foodMenu = item as? FoodMenu {
                return collectionView.dequeueConfiguredReusableCell(using: foodCellRegistration, for: indexPath, item: foodMenu)
            } else if let convenienceList = item as? ConvenienceList {
                return collectionView.dequeueConfiguredReusableCell(using: convenienceCellRegistration, for: indexPath, item: convenienceList)
            } else if let brandList = item as? Brand {
                return collectionView.dequeueConfiguredReusableCell(using: brandCellRegistration, for: indexPath, item: brandList)
            }
            return nil
        }
        var snapshot = NSDiffableDataSourceSnapshot<CategorySection, Facility>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Facility.allCases)
        categoryDataSource.apply(snapshot)
        categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let selectedFacility = BehaviorSubject<Facility>(value: .foodMenu)
        let input = FacilityViewModel.Input(viewWillAppear: viewWillAppear,
                                            selectedFacility: selectedFacility.asObservable())
        let output = viewModel.transform(input: input)
        titleLabel.text = output.serviceArea.fullName
        addressLabel.text = output.serviceArea.address
        
        categoryCollectionView.rx.itemSelected
            .subscribe(onNext: { index in
                guard let facility = self.categoryDataSource.itemIdentifier(for: index) else {
                    return
                }
                selectedFacility.onNext(facility)
            })
            .disposed(by: disposeBag)
        
        output.foodMenuList
            .drive(onNext: { foodMenu in
                self.appleSnapShot(with: foodMenu)
            })
            .disposed(by: disposeBag)
        
        // TODO: - 휴게소 셀 ui마무리
        // TODO: - 휴게소 셀 didselectrowAt연결
        // TODO: - 이용하는 고속도로 없음 뷰에 popViewController 버튼추가
        // TODO: - 천안논산고속도로 휴게소 없을 떄 아얘 테이블뷰 안보여주기
        
        // TODO: - 빈배열일때 어떻게 정보없음 나타낼지 생각하기
        // TODO: - API키 관리
        
        // TODO: - 로드뷰 화면 개선하기
        
        // MARK: - 앱 출시하고 할 일
        // TODO: - 카드뷰컨 placeHolderCell 만들어서 보여주기
        // TODO: - 카드뷰컨 세그멘트전환할때 컬렉션뷰 좀 더 빠릿빠릿하게 바꾸기
        // TODO: - 캐싱
        // TODO: - 유가 API로 주변지역보다 유가높/낮음 나타내기
        
        
        output.convenienceList
            .drive(onNext: { convenienceList in
                self.appleSnapShot(with: convenienceList)
            })
            .disposed(by: disposeBag)
        
        output.brandList
            .drive(onNext: { brandList in
                self.appleSnapShot(with: brandList)
            })
            .disposed(by: disposeBag)
        
        output.gasStation
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { gasStation in
                self.gasStationLabel.text = output.serviceArea.gasStationFullName
                self.telNoLabel.text = output.serviceArea.telNo
                self.showGasStackView(gasStation: gasStation)
            })
            .disposed(by: disposeBag)
    }
    
    private func appleSnapShot(with item: [AnyHashable]) {
        var snapshot = NSDiffableDataSourceSnapshot<FacilitySection, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        self.facilityDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func showGasStackView(gasStation: GasStation) {
        let gasPriceView = GasPriceStackView()
        view.addSubview(gasPriceView)
        gasPriceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        gasPriceView.anchor(top: telNoLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10)
        gasPriceView.bindViewModel(with: gasStation)
    }
    
    deinit {
        viewModel.removeFromSuperview()
    }
}
