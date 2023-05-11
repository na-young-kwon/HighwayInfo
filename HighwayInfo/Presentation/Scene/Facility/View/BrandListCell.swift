//
//  BrandListCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/11.
//

import UIKit

final class BrandListCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        titleLabel.centerY(inView: stackView)
        descriptionLabel.centerY(inView: stackView)
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = .white
        divider.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        addSubview(divider)
        divider.anchor(top: stackView.bottomAnchor, left: leftAnchor, right: rightAnchor)
    }
    
    func bindViewModel(with brand: Brand) {
        print(brand)
        titleLabel.text = brand.name
        descriptionLabel.text = brand.operatingTime
    }
}
