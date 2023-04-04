//
//  SearchView.swift
//  Pods
//
//  Created by 권나영 on 2023/04/04.
//

import UIKit

class SearchView: UIView {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .lightGray
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(textField)
        textField.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 100, paddingLeft: 20, paddingRight: 20, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
