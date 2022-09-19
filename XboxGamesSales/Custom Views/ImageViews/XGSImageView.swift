//
//  XGSImageView.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import UIKit

class XGSImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 5
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray4
    }
    
    func downloadImage(fromURL url: String?) {
        guard let url = url else { return }
        
        image = nil
        let duration = cache.object(forKey: NSString(string: url)) != nil ? 0 : 0.3
        
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
                    self.image = image
                }
            }
        }
    }
}
