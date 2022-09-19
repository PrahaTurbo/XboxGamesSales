//
//  XGSAlertVC.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 08.09.2022.
//

import UIKit

protocol XGSAlertVCDelegate: AnyObject {
    func didTapActionButton()
}

class XGSAlertVC: UIViewController {

    let containerView = XGSAlertContainerView()
    let titleLabel = XGSLabel(textAlignment: .center, fontSize: 20, weight: .bold)
    let messageLabel = XGSBodyLabel(textAlignment: .center)
    let actionButton = XGSButton(color: .systemGreen, title: "Ок")
    
    weak var delegate: XGSAlertVCDelegate!
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
        
    init(title: String, messsage: String, buttonTitle: String) {
        self.alertTitle = title
        self.message = messsage
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(containerView, titleLabel, actionButton, messageLabel)
        
        configureBackgroundView()
        configureUIElements()
        layoutUI()
    }
    
    private func configureBackgroundView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    private func configureUIElements() {
        titleLabel.text = alertTitle ?? "Что-то пошло не так"

        actionButton.setTitle(buttonTitle ?? "Ок", for: .normal)
        actionButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        messageLabel.text = message ?? "Не удалось обработать запрос"
        messageLabel.numberOfLines = 4
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    @objc private func action() {
        dismiss(animated: true)
        delegate.didTapActionButton()
    }
}
