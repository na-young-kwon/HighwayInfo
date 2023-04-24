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

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    }
    
    func bind(_ viewModel: LocationInfo) {
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.address
    }
}
