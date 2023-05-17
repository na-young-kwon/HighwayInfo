//
//  FacilityCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/10.
//

import UIKit

final class FacilityCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            let backgroundAlpha = isSelected ? 0.3 : 0.1
            backgroundColor = UIColor.red.withAlphaComponent(backgroundAlpha)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = UIColor.red.withAlphaComponent(0.1)
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 3, paddingRight: 3)
        titleLabel.centerY(inView: contentView)
    }
    
    func bindViewModel(with facility: Facility) {
        titleLabel.text = facility.stringValue
    }
}
