//
//  EmptyView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import UIKit
import RxSwift
import RxCocoa

final class EmptyView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "경로상 이용예정인 고속도로가 없습니다."
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor.blueGray_textColor
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.skyBlueColor
        button.setTitle("돌아가기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var backButtonTapped: Observable<Void> {
        backButton.rx.tap.asObservable()
    }
    
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
        backButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
}
