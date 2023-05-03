//
//  ServiceCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/01.
//

import UIKit

final class ServiceCell: UICollectionViewCell {
    private lazy var spinner = UIActivityIndicatorView(style: .medium)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let telLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSpinner()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSpinner() {
        contentView.addSubview(spinner)
        spinner.startAnimating()
        spinner.centerX(inView: contentView)
        spinner.centerY(inView: contentView)
    }
    
    private func configureUI() {
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        let stackView = UIStackView(arrangedSubviews: [titleLabel, addressLabel, telLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    func bindViewModel(with serviceArea: ServiceArea) {
        spinner.stopAnimating()
        titleLabel.text = serviceArea.name
        addressLabel.text = serviceArea.address
        telLabel.text = serviceArea.telNo
    }
}
