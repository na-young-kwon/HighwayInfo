//
//  DetailViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/04.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var toggleBackground: UIView!
    @IBOutlet weak var toggleForeground: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        whiteView.layer.cornerRadius = 15
        toggleBackground.layer.cornerRadius = 10
        toggleForeground.layer.cornerRadius = 10
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "뒤로가기", style: .plain, target: nil, action: nil)
    }
}
