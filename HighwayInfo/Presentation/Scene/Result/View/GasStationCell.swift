//
//  GasStationCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/01.
//

import UIKit

final class GasStationCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let gasolineLabel: UILabel = {
        let label = UILabel()
        label.text = "휘발유"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let gasolinePriceLabel: UILabel = {
        let label = PaddingLabel()
        label.textColor = .white
        label.layer.cornerRadius = 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = .mainBlueColor
        return label
    }()
    
    private let dieselLabel: UILabel = {
        let label = UILabel()
        label.text = "경유"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let dieselPriceLabel: UILabel = {
        let label = PaddingLabel()
        label.textColor = .white
        label.layer.cornerRadius = 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = .mainBlueColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bindViewModel(with gasStation: GasStation) {
        titleLabel.text = gasStation.name
        gasolinePriceLabel.text = gasStation.gasolinePrice
        dieselPriceLabel .text = gasStation.dieselPrice
    }
    
    private func configureUI() {
        let gasolineStack = UIStackView(arrangedSubviews: [gasolineLabel, gasolinePriceLabel])
        let dieselStack = UIStackView(arrangedSubviews: [dieselLabel, dieselPriceLabel])
        gasolineStack.axis = .horizontal
        gasolineStack.distribution = .fill
        gasolineStack.alignment = .center
        gasolineStack.spacing = 10
        dieselStack.axis = .horizontal
        dieselStack.distribution = .fill
        dieselStack.alignment = .center
        dieselStack.spacing = 10

        addSubview(titleLabel)
        addSubview(gasolineStack)
        addSubview(dieselStack)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        gasolineStack.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, right: titleLabel.rightAnchor, paddingTop: 20)
        dieselStack.anchor(top: gasolineStack.bottomAnchor, left: titleLabel.leftAnchor, right: titleLabel.rightAnchor, paddingTop: 10)
        gasolinePriceLabel.widthAnchor.constraint(equalTo: gasolineStack.widthAnchor, multiplier: 0.55).isActive = true
        dieselPriceLabel.widthAnchor.constraint(equalTo: dieselStack.widthAnchor, multiplier: 0.55).isActive = true
    }
}
