//
//  ScreenshotCell.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 10.09.2022.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    static let reuseID = "ScreenshotCell"
    
    let screenshotImageView = XGSImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented"
)
    }
    
    func set(screenshotUrl: String) {
        screenshotImageView.downloadImage(fromURL: screenshotUrl)
    }
    
    private func configure() {
        addSubview(screenshotImageView)
        screenshotImageView.contentMode = .scaleAspectFill
        
        screenshotImageView.pinToEdges(of: self)
    }
}
