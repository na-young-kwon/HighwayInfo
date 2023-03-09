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
    @IBOutlet weak var toggleForeground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accidentButton: UIButton!
    @IBOutlet weak var constructionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        whiteView.layer.cornerRadius = 15
        toggleBackground.layer.cornerRadius = 10
        toggleForeground.layer.cornerRadius = 10
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: AccidentCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AccidentCell.reuseID)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    @IBAction func accidentButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.toggleForeground.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @IBAction func constructionButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.toggleForeground.transform = CGAffineTransform(translationX: 175, y: 0)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        print("새로고침 버튼 눌림")
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
