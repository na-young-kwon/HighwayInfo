//
//  EmptyServiceAreaView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/19.
//

import UIKit

final class EmptyServiceAreaView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이용 가능한 휴게소가 없어요."
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemGray3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 75)
        titleLabel.centerX(inView: self)
    }
}
