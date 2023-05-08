//
//  CategoryStackView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/06.
//

import UIKit

final class CategoryStackView: UIView {
    private let sleepingView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let showerView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let laundryView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let restAreaView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let marketView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var serviceArea: ServiceArea? {
        didSet {
            configureUI(with: serviceArea!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI(with serviceArea: ServiceArea) {
        sleepingView.image = serviceArea.sleepingRoom == true ? UIImage(named: "sleeping") : UIImage()
        showerView.image = serviceArea.showerRoom == true ? UIImage(named: "shower") : UIImage()
        laundryView.image = serviceArea.laundryRoom == true ? UIImage(named: "laundry") : UIImage()
        restAreaView.image = serviceArea.restArea == true ? UIImage(named: "restArea") : UIImage()
        marketView.image = serviceArea.market == true ? UIImage(named: "market") : UIImage()
        let stackView = UIStackView(arrangedSubviews: [sleepingView, showerView, laundryView, restAreaView, marketView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                         paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        sleepingView.widthAnchor.constraint(equalTo: sleepingView.heightAnchor, multiplier: 1).isActive = true
        showerView.widthAnchor.constraint(equalTo: showerView.heightAnchor, multiplier: 1).isActive = true
        laundryView.widthAnchor.constraint(equalTo: laundryView.heightAnchor, multiplier: 1).isActive = true
        restAreaView.widthAnchor.constraint(equalTo: restAreaView.heightAnchor, multiplier: 1).isActive = true
        marketView.widthAnchor.constraint(equalTo: marketView.heightAnchor, multiplier: 1).isActive = true
        sleepingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        showerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        laundryView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        restAreaView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        marketView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
    }
}
