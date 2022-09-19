//
//  UIView+Ext.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func showEmptyStateView(with message: String) {
        let emptyStateView = XGSEmptyStateView(message: message)
        emptyStateView.frame = self.bounds
        self.addSubview(emptyStateView)
    }
}
