//
//  TipView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/14.
//

import UIKit

class TipView: UIView {
    init(
        tipStartX: CGFloat,
        tipWidth: CGFloat,
        tipHeight: CGFloat,
        title: String
    ) {
        super.init(frame: .zero)
        self.addLabel(with: title)
        let backColor = UIColor.black.withAlphaComponent(0.6)
        let path = CGMutablePath()
        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth
        
        self.backgroundColor = backColor
        path.move(to: CGPoint(x: tipStartX, y: 0))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: -tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = backColor.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel(with title: String) {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 8)
        titleLabel.numberOfLines = 0
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let newBounds = titleLabel.bounds.insetBy(dx: 10, dy: 16)
        titleLabel.bounds = newBounds
    }
}
