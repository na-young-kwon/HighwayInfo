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

    }
    
    func configureUI(for route: Route) {
        titleLabel.text = route.name + "고속도로"
    }
}
