//
//  DefaultDealCell.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 07.09.2022.
//

import UIKit

class DefaultDealCell: DealCell {
    
    static let reuseID = "OrdinaryDealCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func set(deal: Deal, currencySymbol: String, exchangeRate: Double) {
        super.set(deal: deal, currencySymbol: currencySymbol, exchangeRate: exchangeRate)
        
        let currentPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.currentPrice.exchange(exchangeRate) : String(deal.currentPrice))
        let oldPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.oldPrice.exchange(exchangeRate) : String(deal.oldPrice))
        
        currentPriceLabel.text = currentPriceString
        secondPriceLabel.attributedText = NSAttributedString(string: oldPriceString, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
    }
    
    private func configure() {
        secondPriceLabel.textColor = .secondaryLabel
    }
}
