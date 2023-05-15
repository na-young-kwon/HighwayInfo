//
//  GasPriceStackView.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/05/15.
//

import UIKit

final class GasPriceStackView: UIView {
    private let titleImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    private let gasolineLabel: UILabel = {
        let label = UILabel()
        label.text = "휘발유"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let gasolinePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let dieselLabel: UILabel = {
        let label = UILabel()
        label.text = "경유"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let dieselPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let lpgLabel: UILabel = {
        let label = UILabel()
        label.text = "LPG"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let lpgPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        let gasolineStack = UIStackView(arrangedSubviews: [gasolineLabel, gasolinePriceLabel])
        let dieselStack = UIStackView(arrangedSubviews: [dieselLabel, dieselPriceLabel])
        let lpgStack = UIStackView(arrangedSubviews: [lpgLabel, lpgPriceLabel])
        gasolineStack.axis = .vertical
        gasolineStack.spacing = 5
        gasolineStack.alignment = .center
        gasolineStack.distribution = .fillProportionally
        dieselStack.axis = .vertical
        dieselStack.spacing = 5
        dieselStack.alignment = .center
        dieselStack.distribution = .fillEqually
        lpgStack.axis = .vertical
        lpgStack.spacing = 5
        lpgStack.alignment = .center
        lpgStack.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [gasolineStack, dieselStack, lpgStack])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 15
        
        addSubview(titleImage)
        addSubview(stackView)
        titleImage.widthAnchor.constraint(equalTo: titleImage.heightAnchor).isActive = true
        titleImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        titleImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        stackView.anchor(top: topAnchor, left: titleImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor,
                         paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        let divider = UIView()
        addSubview(divider)
        divider.backgroundColor = .white
        divider.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
        divider.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        divider.anchor(top: stackView.topAnchor, left: gasolineStack.rightAnchor, paddingTop: 15, paddingLeft: 1)

        let secondDivider = UIView()
        addSubview(secondDivider)
        secondDivider.backgroundColor = .white
        secondDivider.widthAnchor.constraint(equalToConstant: 1.5).isActive = true
        secondDivider.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        secondDivider.anchor(top: stackView.topAnchor, left: dieselStack.rightAnchor, paddingTop: 15, paddingLeft: 1)
    }
    
    func bindViewModel(with gasStation: GasStation) {
        titleImage.image = UIImage(named: gasStation.oilCompanyImage ?? "")
        gasolinePriceLabel.text = gasStation.gasolinePrice
        dieselPriceLabel.text = gasStation.dieselPrice
        lpgPriceLabel.text = gasStation.lpgPrice
    }
}
