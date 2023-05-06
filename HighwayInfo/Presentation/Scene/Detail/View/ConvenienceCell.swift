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
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .mainBlueColor: .clear
        }
    }
    
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
        stackView.spacing = 3
        stackView.alignment = .center
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        titleImage.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.65).isActive = true
        titleImage.widthAnchor.constraint(equalTo: titleImage.heightAnchor, multiplier: 1).isActive = true
    }
    
    func bindViewModel(with convenience: Convenience) {
        titleImage.image = UIImage(named: convenience.imageName)
        label.text = convenience.stringValue
    }
}
