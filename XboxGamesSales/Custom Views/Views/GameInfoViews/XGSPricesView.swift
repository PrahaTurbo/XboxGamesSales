//
//  XGSPricesView.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 11.09.2022.
//

import UIKit

protocol XGSPricesViewDelegate: AnyObject {
    func didTapStoreButton()
}

class XGSPricesView: UIView {
    
    let actionButton = XGSButton(color: .systemGreen, title: "Microsoft Store")
    let currentPriceLabel = XGSLabel(textAlignment: .left, fontSize: 25, weight: .bold)
    var secondPriceLabel = XGSLabel(textAlignment: .left, fontSize: 15, weight: .regular)
    let goldLabel = XGSBadgeLabel(type: .gold)
    
    var deal: Deal
    var currencySymbol: String
    var exchangeRate: Double
    
    weak var delegate: XGSPricesViewDelegate!
    
    init(deal: Deal, currencySymbol: String, exchangeRate: Double, delegate: XGSPricesViewDelegate) {
        self.deal = deal
        self.currencySymbol = currencySymbol
        self.exchangeRate = exchangeRate
        self.delegate = delegate
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(actionButton, currentPriceLabel, secondPriceLabel, goldLabel)

        configureBackgroundView()
        layoutUI()
        configureUIElements()
    }
    
    private func configureBackgroundView() {
        layer.cornerRadius = 10
        backgroundColor = K.Colors.cardColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureUIElements() {
        if deal.discountWithGold {
            let goldPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.goldPrice.exchange(exchangeRate) : String(deal.goldPrice))
            let currentPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.currentPrice.exchange(exchangeRate) : String(deal.currentPrice))
            
            currentPriceLabel.text = goldPriceString
            secondPriceLabel.attributedText = NSAttributedString(string: currentPriceString, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            currentPriceLabel.textColor = .systemYellow
        } else {
            let currentPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.currentPrice.exchange(exchangeRate) : String(deal.currentPrice))
            let oldPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.oldPrice.exchange(exchangeRate) : String(deal.oldPrice))
            
            currentPriceLabel.text = currentPriceString
            secondPriceLabel.attributedText = NSAttributedString(string: oldPriceString, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        }
        
        secondPriceLabel.textColor = .secondaryLabel

        goldLabel.font = .systemFont(ofSize: 12, weight: .black)
        goldLabel.isHidden = !deal.discountWithGold
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    private func layoutUI() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            actionButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            currentPriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            currentPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            currentPriceLabel.bottomAnchor.constraint(equalTo: actionButton.centerYAnchor),
            
            secondPriceLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor),
            secondPriceLabel.leadingAnchor.constraint(equalTo: currentPriceLabel.leadingAnchor),
            secondPriceLabel.trailingAnchor.constraint(equalTo: currentPriceLabel.trailingAnchor),
            
            goldLabel.topAnchor.constraint(equalTo: currentPriceLabel.topAnchor),
            goldLabel.leadingAnchor.constraint(equalTo: currentPriceLabel.trailingAnchor),
            goldLabel.bottomAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor),
        ])
    }
    
    @objc private func actionButtonTapped() {
        delegate.didTapStoreButton()
    }
}
