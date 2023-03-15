//
//  AccidentCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

class AccidentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var accidentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 셀간격
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
    }
    
    func bind(_ viewModel: AccidentViewModel) {
        titleLabel.text = viewModel.place
        directionLabel.text = viewModel.direction
        startTimeLabel.text = "시작시간 " + viewModel.startTime
        endTimeLabel.text = "종료예정시간 " + viewModel.estimatedEndTime
        descriptionLabel.text = viewModel.description + " (\(viewModel.restrictType) 차단)"
    }
}
