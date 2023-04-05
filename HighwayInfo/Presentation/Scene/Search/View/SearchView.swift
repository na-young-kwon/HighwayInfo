//
//  SearchView.swift
//  Pods
//
//  Created by 권나영 on 2023/04/04.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func dismissSearchView()
}


class SearchView: UIView {
    weak var delegate: SearchViewDelegate?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 0.25
        textField.layer.borderColor = UIColor.white.cgColor
        // background
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 2
        textField.layer.shadowOffset = CGSize.zero
        textField.layer.shadowColor = UIColor.gray.cgColor
        // padding
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.placeholder = "검색"
        return textField
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissSearchView), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hideKeyboardWhenTappedAround()
        backgroundColor = .white
        addSubview(textField)
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 100, paddingLeft: 10, width: 40, height: 40)
        textField.anchor(top: backButton.topAnchor, left: backButton.rightAnchor, right: rightAnchor, paddingRight: 20, height: 40)
        textField.centerY(inView: backButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissSearchView() {
        endEditing(true)
        delegate?.dismissSearchView()
    }
}
