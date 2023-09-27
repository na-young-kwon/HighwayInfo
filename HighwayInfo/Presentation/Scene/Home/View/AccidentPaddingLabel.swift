//
//  PaddingLabel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/09/27.
//

import UIKit

final class AccidentPaddingLabel: UILabel {
    
    private let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 3
        font = .systemFont(ofSize: 13)
        backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
