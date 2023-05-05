//
//  ConvenienceCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/05.
//

import UIKit

final class ConvenienceCell: UICollectionViewCell {
    private let titleImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray6
//        image.layer.cornerRadius = 10
//        image.clipsToBounds = true
        return image
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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
        let stackView = UIStackView(arrangedSubviews: [titleImage, label])
        stackView.axis = .vertical
        stackView.spacing = 10
//        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    func bindViewModel(with convenience: Convenience) {
        titleImage.image = UIImage(named: convenience.imageName)
        label.text = convenience.stringValue
    }
}
