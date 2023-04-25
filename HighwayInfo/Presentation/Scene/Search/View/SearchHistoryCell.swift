//
//  SearchHistoryCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import UIKit

class SearchHistoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ viewModel: LocationInfo) {
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.address
    }
}
