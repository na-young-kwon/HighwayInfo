//
//  RoadViewController.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/03.
//

import UIKit

class RoadViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
    }

    private func configureUI() {
        tableView.layer.cornerRadius = 15
        hidesBottomBarWhenPushed = true
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: RoadCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RoadCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
    }
}

extension RoadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoadCell.reuseID, for: indexPath) as? RoadCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension RoadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: DetailViewController.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}
