//
//  SearchView.swift
//  Pods
//
//  Created by 권나영 on 2023/04/04.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

protocol SearchViewDelegate: AnyObject {
    func dismissSearchView()
    func currentLocation() -> CLLocationCoordinate2D?
}

class SearchView: UIView {
    enum Section {
        case search
    }
    
    var viewModel: SearchViewModel? {
        didSet {
            bindViewModel()
        }
    }
    weak var delegate: SearchViewDelegate?
    private let disposeBag = DisposeBag()
    private var dataSource: UITableViewDiffableDataSource<Section, LocationInfo>!
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 0.25
        textField.layer.borderColor = UIColor.white.cgColor
        // background
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 2
        textField.layer.shadowOffset = CGSize.zero
        textField.layer.shadowColor = UIColor.gray.cgColor
        // padding
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.placeholder = "검색"
        return textField
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissSearchView), for: .touchUpInside)
        return button
    }()
    
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureTableView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
        backgroundColor = .white
        addSubview(textField)
        addSubview(backButton)
        addSubview(tableView)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 100, paddingLeft: 10, width: 40, height: 40)
        textField.anchor(top: backButton.topAnchor, left: backButton.rightAnchor, right: rightAnchor, paddingRight: 20, height: 40)
        textField.centerY(inView: backButton)
        tableView.anchor(top: textField.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12)
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: SearchResultCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SearchResultCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, LocationInfo>(tableView: tableView) { (tableView: UITableView, indexPath: IndexPath, viewModel: LocationInfo) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as? SearchResultCell else {
                return UITableViewCell()
            }
            cell.bind(viewModel: viewModel)
            return cell
        }
    }
    
    private func applySnapshot(with viewModel: [LocationInfo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, LocationInfo>()
        snapShot.appendSections([.search])
        snapShot.appendItems(viewModel)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func bindViewModel() {
        let keyword = textField.rx.text.orEmpty.asObservable()
        let selectedLocation = PublishSubject<LocationInfo?>()
        let currentLocation = delegate?.currentLocation()

        let input = SearchViewModel.Input(searchKeyword: keyword,
                                          itemSelected: selectedLocation.asObservable(),
                                          currentLocation: Observable.of(currentLocation))
        let output = viewModel?.transform(input: input)
        
        tableView.rx.itemSelected.subscribe(onNext: { index in
            let location = self.dataSource.itemIdentifier(for: index)
            selectedLocation.onNext(location)
        })
        .disposed(by: disposeBag)
        
        output?.searchResult
            .subscribe(onNext: { result in
                self.applySnapshot(with: result)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func dismissSearchView() {
        endEditing(true)
        textField.text = ""
        delegate?.dismissSearchView()
        var snapShot = dataSource.snapshot()
        snapShot.deleteAllItems()
        dataSource.apply(snapShot)
    }
}
