//
//  HighwayCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/01.
//

import UIKit

class HighwayCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black.withAlphaComponent(0.7)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bindViewModel(with highway: HighwayInfo) {
        print(highway.name)
        label.text = highway.name
    }
    
    private func configureUI() {
        backgroundColor = .systemGray6
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBackground.cgColor
        contentView.addSubview(label)
        let horizontalPadding = 8.0
        let verticalPadding = 12.0
        label.anchor(top: contentView.topAnchor,
                     left: contentView.leftAnchor,
                     bottom: contentView.bottomAnchor,
                     right: contentView.rightAnchor,
                     paddingTop: horizontalPadding,
                     paddingLeft: verticalPadding,
                     paddingBottom: horizontalPadding,
                     paddingRight: verticalPadding
        )
    }
}
