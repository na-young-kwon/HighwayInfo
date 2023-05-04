//
//  PaddingLabel.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/04.
//

import UIKit

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 1.8, left: 2.5, bottom: 1.8, right: 2.5)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
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
