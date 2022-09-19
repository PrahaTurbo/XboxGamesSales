//
//  XGSEmptyStateView.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 08.09.2022.
//

import UIKit

class XGSEmptyStateView: UIView {

    let messageLabel = XGSLabel(textAlignment: .center, fontSize: 25, weight: .bold)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        addSubview(messageLabel)
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
