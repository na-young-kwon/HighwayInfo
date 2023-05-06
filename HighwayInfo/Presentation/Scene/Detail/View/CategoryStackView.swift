//
//  CategoryStackView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/06.
//

import UIKit

final class CategoryStackView: UIView {
    private let feedingView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
        feedingView.image = serviceArea.feedingRoom == true ? UIImage(named: "feeding") : UIImage()
        sleepingView.image = serviceArea.sleepingRoom == true ? UIImage(named: "sleeping") : UIImage()
        showerView.image = serviceArea.showerRoom == true ? UIImage(named: "shower") : UIImage()
        laundryView.image = serviceArea.laundryRoom == true ? UIImage(named: "laundry") : UIImage()
        let stackView = UIStackView(arrangedSubviews: [feedingView, sleepingView, showerView, laundryView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                         paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        feedingView.widthAnchor.constraint(equalTo: feedingView.heightAnchor, multiplier: 1).isActive = true
        sleepingView.widthAnchor.constraint(equalTo: sleepingView.heightAnchor, multiplier: 1).isActive = true
        showerView.widthAnchor.constraint(equalTo: showerView.heightAnchor, multiplier: 1).isActive = true
        laundryView.widthAnchor.constraint(equalTo: laundryView.heightAnchor, multiplier: 1).isActive = true
        feedingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        sleepingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        showerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        laundryView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
    }
}
