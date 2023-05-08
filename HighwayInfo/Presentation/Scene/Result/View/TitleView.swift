//
//  TitleSupplementaryView.swift
//  Pods
//
//  Created by 권나영 on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa

final class TitleView: UICollectionReusableView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.black.withAlphaComponent(0.7),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "더보기", attributes: attribute)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    
    var moreButtonTapped: Observable<Void> {
        button.rx.tap.asObservable()
    }
    
    func setTitle(with text: String) {
        label.text = text
    }
    
    func hideShowMoreButton() {
        button.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [label, button])
        stack.spacing = 10
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.axis = .horizontal
        addSubview(stack)
        stack.anchor(top: topAnchor,
                     left: leftAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor,
                     paddingLeft: 15,
                     paddingBottom: 10,
                     paddingRight: 15
        )
    }
}
