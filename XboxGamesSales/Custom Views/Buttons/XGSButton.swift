//
//  XGSButton.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 03.09.2022.
//

import UIKit

class XGSButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String) {
        self.init(frame: .zero)
        set(color: color, title: title)
    }
    
    private func configure() {
        layer.cornerRadius = 22
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        
    }
    
    func set(color: UIColor, title: String) {
        setTitle(title, for: .normal)
        backgroundColor = color
    }
}
