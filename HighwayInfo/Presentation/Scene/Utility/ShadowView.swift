//
//  ShadowView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/04.
//

import UIKit

final class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.6
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: .allCorners,
                                        cornerRadii: CGSize(width: 8, height: 8)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
