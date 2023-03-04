//
//  ViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/02.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var toggleBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whiteView.layer.cornerRadius = 15
        toggleBackground.layer.cornerRadius = 10
        configureTableView()
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: AccidentCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AccidentCell.reuseID)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccidentCell.reuseID, for: indexPath) as? AccidentCell else {
            return UITableViewCell()
        }
        return cell
    }
}
