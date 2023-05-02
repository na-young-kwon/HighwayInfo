//
//  SearchHeaderView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/25.
//

import UIKit
import RxSwift
import RxCocoa

class SearchHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    private let label: UILabel = {
        let label = UILabel()
        label.text = "최근 검색 기록"
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    var resetButtonTapped: Observable<Void> {
        resetButton.rx.tap.asObservable()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [label, resetButton])
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .horizontal
        addSubview(stack)
        stack.anchor(top: topAnchor,
                     left: leftAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor,
                     paddingLeft: 15,
                     paddingBottom: 10,
                     paddingRight: 15
        )
    }
}
