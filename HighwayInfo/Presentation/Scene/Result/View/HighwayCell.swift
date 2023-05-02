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
        label.font = .systemFont(ofSize: 15)
        label.backgroundColor = .brown
        label.textColor = .systemGray2
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
        // border 넣기
        contentView.addSubview(label)
        let padding = 3.0
        label.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                     paddingTop: padding, paddingLeft: padding, paddingBottom: padding, paddingRight: padding)
    }
}
