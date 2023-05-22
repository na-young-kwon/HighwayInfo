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

final class SearchViewController: UIViewController {
    enum Section {
        case search
    }
    
    var viewModel: SearchViewModel?
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
        textField.placeholder = " 검색"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        configureUI()
        configureTableView()
        configureDataSource()
        bindViewModel()
    }
    
    private func configureUI() {
        view.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(historyTableView)
        view.addSubview(searchTableView)

        textField.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 20, paddingRight: 20, height: 40)
        searchTableView.anchor(top: textField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 12)
        historyTableView.anchor(top: textField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5)
    }
    
    private func configureTableView() {
        let searchNib = UINib(nibName: SearchResultCell.reuseID, bundle: nil)
        let historyNib = UINib(nibName: SearchHistoryCell.reuseID, bundle: nil)
        historyTableView.keyboardDismissMode = .onDrag
        searchTableView.keyboardDismissMode = .onDrag
        historyTableView.separatorStyle = .none
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
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid()
        let searchKeyword = textField.rx.text.orEmpty.asObservable()
        let selectedLocation = PublishSubject<LocationInfo?>()
        
        let input = SearchViewModel.Input(viewWillAppear: viewWillAppear,
                                          searchKeyword: searchKeyword,
                                          itemSelected: selectedLocation.asObservable())
        let output = viewModel?.transform(input: input)
        
        textField.rx.text.orEmpty
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] empty in
                self?.searchTableView.alpha = empty ? 0 : 1
            })
            .disposed(by: disposeBag)
        
        searchTableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            self?.searchTableView.deselectRow(at: index, animated: false)
            let location = self?.searchDataSource.itemIdentifier(for: index)
            self?.showLoadingIndicator()
            selectedLocation.onNext(location)
        })
        .disposed(by: disposeBag)
        
        historyTableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            self?.historyTableView.deselectRow(at: index, animated: false)
            let location = self?.historyDataSource.itemIdentifier(for: index)
            self?.showLoadingIndicator()
            selectedLocation.onNext(location)
        })
        .disposed(by: disposeBag)
        
        output?.searchResult
            .subscribe(onNext: { [weak self] result in
                var snapShot = NSDiffableDataSourceSnapshot<Section, LocationInfo>()
                snapShot.appendSections([.search])
                snapShot.appendItems(result)
                self?.searchDataSource.apply(snapShot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        
        output?.searchHistory
            .subscribe(onNext: { [weak self] history in
                var snapShot = NSDiffableDataSourceSnapshot<Section, LocationInfo>()
                snapShot.appendSections([.search])
                snapShot.appendItems(history)
                self?.historyDataSource.apply(snapShot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func showLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.centerX(inView: view)
        loadingIndicator.centerY(inView: view)
        loadingIndicator.play { [weak self] finished in
            self?.loadingIndicator.removeFromSuperview()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHeaderView.reuseIdentifier) as! SearchHeaderView
        view.resetButtonTapped
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.deleteHistory()
            })
            .disposed(by: disposeBag)
        return view
    }
}
