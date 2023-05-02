//
//  TitleSupplementaryView.swift
//  Pods
//
//  Created by 권나영 on 2023/05/02.
//

import UIKit

class TitleView: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
