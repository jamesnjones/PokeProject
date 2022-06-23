//
//  image+EXT.swift
//  PokeProject
//
//  Created by james Jones on 20/06/2022.
//

import UIKit

extension UIImageView {
    // An extension to assist with loading an image from JSON Responses 
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        DispatchQueue.main.async {
            self.contentMode = mode
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
