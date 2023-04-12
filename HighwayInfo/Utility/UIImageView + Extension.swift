//
//  UIImage + Extension.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/04/07.
//

import UIKit

extension UIImageView {
    func loadFrom(url: String?) {
        guard let url = url, let url = URL(string: url) else {
            self.image = nil
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data else {
                self.image = nil
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }.resume()
    }
}
