//
//  EmptyView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import UIKit

final class EmptyView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "이용예정인 고속도로가 없습니다"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.skyBlueColor
        button.setTitle("돌아가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
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
        addSubview(label)
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.6
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        label.anchor(top: topAnchor, paddingTop: 100)
        label.centerX(inView: self)
        
        addSubview(backButton)
        backButton.anchor(top: label.bottomAnchor, paddingTop: 20)
        backButton.centerX(inView: self)
        backButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
