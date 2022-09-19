//
//  GoldDealCell.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 07.09.2022.
//

import UIKit

class GoldDealCell: DealCell {
    
    static let reuseID = "GoldDealCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func set(deal: Deal, currencySymbol: String, exchangeRate: Double) {
        super.set(deal: deal, currencySymbol: currencySymbol, exchangeRate: exchangeRate)
        
        let goldPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.goldPrice.exchange(exchangeRate) : String(deal.goldPrice))
        let currentPriceString = currencySymbol + (AppSettingsManager.shared.convertToRubles ? deal.currentPrice.exchange(exchangeRate) : String(deal.currentPrice))
        
        currentPriceLabel.text = goldPriceString
        secondPriceLabel.attributedText = NSAttributedString(string: currentPriceString, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
    }
    
    private func configure() {                
        currentPriceLabel.textColor = .systemYellow
    }
}
