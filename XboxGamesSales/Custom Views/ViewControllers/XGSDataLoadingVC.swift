//
//  XGSDataLoadingVC.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 07.09.2022.
//

import UIKit

class XGSDataLoadingVC: UIViewController {

    var containerView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 1 }
        
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
                
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
                self.containerView.removeFromSuperview()
            }
        }
    }
}
