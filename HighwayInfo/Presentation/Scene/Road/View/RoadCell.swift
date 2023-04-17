//
//  RoadCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/04.
//

import UIKit

class RoadCell: UITableViewCell {
    @IBOutlet weak var roadImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bindCell(with route: Route) {
        roadImageView.image = UIImage(named: route.number)
        titleLabel.text = route.name + "고속도로"
    }
}
