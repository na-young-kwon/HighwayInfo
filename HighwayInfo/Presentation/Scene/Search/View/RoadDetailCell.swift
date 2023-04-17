//
//  RoadDetailCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/29.
//

import UIKit

class RoadDetailCell: UITableViewCell {
    @IBOutlet weak var accidentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(with road: RoadDetail) {
        titleLabel.text = road.name
        accidentImageView.image = UIImage(named: "forbidden")
    }
}
