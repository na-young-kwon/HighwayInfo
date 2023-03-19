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
    @IBOutlet weak var restrictLabel: UILabel!
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
        startTimeLabel.text = "사고시각: " + viewModel.startTime
        restrictLabel.text = viewModel.restrictType + "통제"
        descriptionLabel.text = viewModel.description

        accidentImageView.loadFrom(url: viewModel.cctvImage ?? "")
        print(viewModel.cctvImage)
    }
}


extension UIImageView {
    func loadFrom(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
