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
import Lottie

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
    private let searchTableView = UITableView()
    private let historyTableView = UITableView()
    private var searchDataSource: UITableViewDiffableDataSource<Section, LocationInfo>!
    private var historyDataSource: UITableViewDiffableDataSource<Section, LocationInfo>!
    private var loadingIndicator: LottieAnimationView = {
        let animation = LottieAnimation.named("GrayLoadingIndicator")
        let view = LottieAnimationView(animation: animation)
        view.loopMode = .loop
        return view
    }()
    
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
        addSubview(historyTableView)
        addSubview(searchTableView)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 100, paddingLeft: 10, width: 40, height: 40)
        textField.anchor(top: backButton.topAnchor, left: backButton.rightAnchor, right: rightAnchor, paddingRight: 20, height: 40)
        textField.centerY(inView: backButton)
        searchTableView.anchor(top: textField.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12)
        historyTableView.anchor(top: textField.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5)
    }
    
    private func configureTableView() {
        let searchNib = UINib(nibName: SearchResultCell.reuseID, bundle: nil)
        let historyNib = UINib(nibName: SearchHistoryCell.reuseID, bundle: nil)
        historyTableView.delegate = self
        searchTableView.showsVerticalScrollIndicator = false
        historyTableView.showsVerticalScrollIndicator = false
        searchTableView.register(searchNib, forCellReuseIdentifier: SearchResultCell.reuseID)
        historyTableView.register(historyNib, forCellReuseIdentifier: SearchHistoryCell.reuseID)
        historyTableView.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchHeaderView.reuseIdentifier)
    }
    
    private func configureDataSource() {
        searchDataSource = UITableViewDiffableDataSource<Section, LocationInfo>(tableView: searchTableView) { (tableView: UITableView, indexPath: IndexPath, viewModel: LocationInfo) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as? SearchResultCell else {
                return UITableViewCell()
            }
            cell.bind(viewModel)
            return cell
        }
        historyDataSource = UITableViewDiffableDataSource<Section, LocationInfo>(tableView: historyTableView) { (tableView: UITableView, indexPath: IndexPath, viewModel: LocationInfo) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryCell.reuseID, for: indexPath) as? SearchHistoryCell else {
                return UITableViewCell()
            }
            cell.bind(viewModel)
            return cell
        }
    }
    
    private func applySnapshot(to dataSource: UITableViewDiffableDataSource<Section, LocationInfo>, with viewModel: [LocationInfo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, LocationInfo>()
        snapShot.appendSections([.search])
        snapShot.appendItems(viewModel)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func bindViewModel() {
        let viewWillAppear = textField.rx.text.orEmpty.map { $0.isEmpty }
        let keyword = textField.rx.text.orEmpty.asObservable()
        let selectedLocation = PublishSubject<LocationInfo?>()
        let currentLocation = delegate?.currentLocation()

        let input = SearchViewModel.Input(viewWillAppear: viewWillAppear,
                                          searchKeyword: keyword,
                                          itemSelected: selectedLocation.asObservable(),
                                          currentLocation: Observable.of(currentLocation))
        let output = viewModel?.transform(input: input)
        
        textField.rx.text.orEmpty
            .map { $0.isEmpty }
            .subscribe(onNext: { empty in
                self.searchTableView.alpha = empty ? 0 : 1
            })
            .disposed(by: disposeBag)
        
        searchTableView.rx.itemSelected.subscribe(onNext: { index in
            self.searchTableView.deselectRow(at: index, animated: false)
            let location = self.searchDataSource.itemIdentifier(for: index)
            self.showLoadingIndicator()
            selectedLocation.onNext(location)
        })
        .disposed(by: disposeBag)
        
        historyTableView.rx.itemSelected.subscribe(onNext: { index in
            self.historyTableView.deselectRow(at: index, animated: false)
            let location = self.historyDataSource.itemIdentifier(for: index)
            self.showLoadingIndicator()
            selectedLocation.onNext(location)
        })
        .disposed(by: disposeBag)
        
        output?.searchResult
            .subscribe(onNext: { result in
                self.applySnapshot(to: self.searchDataSource, with: result)
            })
            .disposed(by: disposeBag)
        
        output?.searchHistory
            .subscribe(onNext: { history in
                self.applySnapshot(to: self.historyDataSource, with: history)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func dismissSearchView() {
        endEditing(true)
        textField.text = ""
        delegate?.dismissSearchView()
        var snapShot = searchDataSource.snapshot()
        snapShot.deleteAllItems()
        searchDataSource.apply(snapShot)
    }
    
    private func showLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.centerX(inView: self)
        loadingIndicator.centerY(inView: self)
        loadingIndicator.play { finished in
            self.loadingIndicator.removeFromSuperview()
        }
    }
}

extension SearchView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHeaderView.reuseIdentifier) as! SearchHeaderView
        return view
    }
}
