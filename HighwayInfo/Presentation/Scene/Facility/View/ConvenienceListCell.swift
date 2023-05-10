//
//  ConvenienceListCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/10.
//

import UIKit

final class ConvenienceListCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let priceLabel: UILabel = {
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
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        titleLabel.centerY(inView: stackView)
        priceLabel.centerY(inView: stackView)
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    func bindViewModel(with convenience: ConvenienceList) {
        titleLabel.text = convenience.name
        titleLabel.text = convenience.description
    }
}
