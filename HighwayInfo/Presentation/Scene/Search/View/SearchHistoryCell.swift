//
//  SearchHistoryCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/22.
//

import UIKit

final class SearchHistoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func bind(_ viewModel: LocationInfo) {
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.address
    }
}
