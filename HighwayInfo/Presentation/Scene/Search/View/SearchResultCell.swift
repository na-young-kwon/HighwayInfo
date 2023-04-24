//
//  SearchResultCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ viewModel: LocationInfo) {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address ?? ""
        businessLabel.text = viewModel.businessName
        distanceLabel.text = viewModel.distance + "km"
    }
}
