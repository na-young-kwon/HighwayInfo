//
//  ServiceListCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/06.
//

import UIKit

final class ServiceListCell: UICollectionViewListCell {private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let categoryStackView = CategoryStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, categoryStackView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center        
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 15, paddingBottom: 6, paddingRight: 4)
        categoryStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func bindViewModel(with serviceArea: ServiceArea) {
        titleLabel.text = serviceArea.serviceName
        categoryStackView.serviceArea = serviceArea
    }
}
