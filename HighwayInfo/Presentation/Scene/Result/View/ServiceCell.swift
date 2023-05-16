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
    private let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.tintColor = UIColor.blueGray_textColor
        return imageView
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private let brandTitleLabel: UILabel = {
        let label = PaddingLabel()
        label.text = "편의시설"
        label.textColor = .white
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.backgroundColor = .mainBlueColor
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
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
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        addSubview(titleLabel)
        addSubview(pinImageView)
        addSubview(addressLabel)
        addSubview(brandTitleLabel)
        addSubview(brandLabel)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        brandTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        
        pinImageView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        pinImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        pinImageView.widthAnchor.constraint(equalTo: pinImageView.heightAnchor).isActive = true
        addressLabel.anchor(top: titleLabel.bottomAnchor, left: pinImageView.rightAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 10)
        brandTitleLabel.anchor(top: pinImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 15)
        brandLabel.anchor(top: brandTitleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 15)
    }
    
    func bindViewModel(with serviceArea: ServiceArea) {
        titleLabel.text = serviceArea.fullName
        addressLabel.text = serviceArea.address
        brandLabel.text = serviceArea.convenience
    }
}
