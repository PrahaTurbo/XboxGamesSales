//
//  XGSLabel.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import UIKit

class XGSLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = .systemFont(ofSize: fontSize, weight: weight)
    }
        
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        numberOfLines = 3
    }
}

