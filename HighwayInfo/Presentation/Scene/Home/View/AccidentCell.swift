//
//  AccidentCell.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit
import RxSwift
import RxCocoa

class AccidentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directionTitleLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var startTimeTitleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var restrictTitleLabel: UILabel!
    @IBOutlet weak var restrictLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var accidentImageView: UIImageView!
    
    private let tapGesture = UITapGestureRecognizer()
    
    var imageViewTap: ControlEvent<UITapGestureRecognizer> {
        return tapGesture.rx.event
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accidentImageView.layoutIfNeeded()
        accidentImageView.clipsToBounds = true
        accidentImageView.layer.cornerRadius = 5
        accidentImageView.contentMode = .scaleToFill
        directionTitleLabel.clipsToBounds = true
        startTimeTitleLabel.clipsToBounds = true
        restrictTitleLabel.clipsToBounds = true
        descriptionTitleLabel.clipsToBounds = true
        directionTitleLabel.layer.cornerRadius = 3
        startTimeTitleLabel.layer.cornerRadius = 3
        restrictTitleLabel.layer.cornerRadius = 3
        descriptionTitleLabel.layer.cornerRadius = 3
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 셀간격
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        addTapGesture()
    }

    func bind(_ viewModel: AccidentViewModel) {
        titleLabel.text = viewModel.place
        directionLabel.text = viewModel.direction
        startTimeLabel.text = viewModel.startTime
        restrictLabel.text = viewModel.restrictType + "통제"
        descriptionLabel.text = viewModel.description
        accidentImageView.loadFrom(url: viewModel.preview)
    }
    
    private func addTapGesture() {
        accidentImageView.addGestureRecognizer(tapGesture)
        accidentImageView.isUserInteractionEnabled = true
    }
}
