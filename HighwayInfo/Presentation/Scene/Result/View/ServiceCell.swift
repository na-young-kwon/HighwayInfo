//
//  ServiceCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/01.
//

import UIKit

final class ServiceCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    private let brandTitleLabel: UILabel = {
        let label = PaddingLabel()
        label.text = "편의시설"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.layer.cornerRadius = 2
        label.backgroundColor = .white
        return label
    }()
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let categoryStackView = CategoryStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        addSubview(titleLabel)
        addSubview(addressLabel)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)

        addressLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        addSubview(categoryStackView)
        categoryStackView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 10, paddingBottom: 10, paddingRight: 15)
        categoryStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func bindViewModel(with serviceArea: ServiceArea) {
        titleLabel.text = serviceArea.fullName
        addressLabel.text = serviceArea.address
        categoryStackView.serviceArea = serviceArea
    }
}
