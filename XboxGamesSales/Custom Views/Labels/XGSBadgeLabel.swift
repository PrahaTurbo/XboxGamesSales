//
//  XGSBadgeLabel.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 07.09.2022.
//

import UIKit

class XGSBadgeLabel: UILabel {
    
    enum BadgeType {
        case blackGamePass, whiteGamePass, gold
    }
    
    var topInset: CGFloat = 3
    var bottomInset: CGFloat = 3
    var leftInset: CGFloat = 6
    var rightInset: CGFloat = 6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: BadgeType) {
        self.init(frame: .zero)
        
        switch type {
        case .blackGamePass:
            text = "GAME PASS"
            textColor = .white
            backgroundColor = .black
            
        case .whiteGamePass:
            text = "GAME PASS"
            textColor = .black
            backgroundColor = .white
            
        case .gold:
            text = "GOLD"
            textColor = .white
            backgroundColor = .systemYellow
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = .boldSystemFont(ofSize: 10)
        textAlignment = .center
        layer.cornerRadius = 3
        clipsToBounds = true
        sizeToFit()
    }
}
