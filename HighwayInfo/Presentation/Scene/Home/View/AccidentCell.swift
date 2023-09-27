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
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let directionTitleLabel: UILabel = {
        let label = AccidentPaddingLabel()
        label.text = "방향"
        return label
    }()
    
    private let startTimeTitleLabel: UILabel = {
        let label = AccidentPaddingLabel()
        label.text = "사고시각"
        return label
    }()
    
    private let restrictTitleLabel: UILabel = {
        let label = AccidentPaddingLabel()
        label.text = "통제"
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = AccidentPaddingLabel()
        label.text = "내용"
        return label
    }()
    
    private let directionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let restrictLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let accidentImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let directionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    private let startTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    private let restrictStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    private let tapGesture = UITapGestureRecognizer()
    
    var imageViewTap: ControlEvent<UITapGestureRecognizer> {
        return tapGesture.rx.event
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accidentImageView.layoutIfNeeded()
        accidentImageView.clipsToBounds = true
        accidentImageView.layer.cornerRadius = 5
        accidentImageView.contentMode = .scaleToFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 셀간격
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 20, right: 5))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        configureShadow()
        configureHierarchy()
        configureConstraints()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureShadow() {
        contentView.backgroundColor = .white.withAlphaComponent(0.95)
        contentView.layer.cornerRadius = 6
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOpacity = 0.3
    }
    
    private func configureHierarchy() {
        contentView.addSubview(stackView)
        contentView.addSubview(directionStackView)
        contentView.addSubview(startTimeStackView)
        contentView.addSubview(restrictStackView)
        contentView.addSubview(descriptionStackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(directionStackView)
        stackView.addArrangedSubview(startTimeStackView)
        stackView.addArrangedSubview(restrictStackView)
        stackView.addArrangedSubview(descriptionStackView)
        directionStackView.addArrangedSubview(directionTitleLabel)
        directionStackView.addArrangedSubview(directionLabel)
        startTimeStackView.addArrangedSubview(startTimeTitleLabel)
        startTimeStackView.addArrangedSubview(startTimeLabel)
        restrictStackView.addArrangedSubview(restrictTitleLabel)
        restrictStackView.addArrangedSubview(restrictLabel)
        descriptionStackView.addArrangedSubview(descriptionTitleLabel)
        descriptionStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    private func addTapGesture() {
        accidentImageView.addGestureRecognizer(tapGesture)
        accidentImageView.isUserInteractionEnabled = true
    }
    
    func bind(_ viewModel: AccidentViewModel) {
        titleLabel.text = viewModel.place
        directionLabel.text = viewModel.direction
        startTimeLabel.text = viewModel.startTime
        restrictLabel.text = viewModel.restrictType + "통제"
        descriptionLabel.text = viewModel.description
        accidentImageView.loadFrom(url: viewModel.preview)
    }
}
