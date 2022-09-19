//
//  XGSAlertVCDelegate+Ext.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 14.09.2022.
//

import UIKit

extension XGSAlertVCDelegate where Self: UIViewController {
    
    func presentXGSAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = XGSAlertVC(title: title, messsage: message, buttonTitle: buttonTitle)
            alertVC.delegate = self
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func didTapActionButton() { }
}
