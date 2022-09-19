//
//  DealCell.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import UIKit

class DealCell: UICollectionViewCell {
        
    let coverImageView = XGSImageView(frame: .zero)
    let titleLabel = XGSLabel(textAlignment: .left, fontSize: 15, weight: .regular)
    let currentPriceLabel = XGSLabel(textAlignment: .left, fontSize: 15, weight: .bold)
    let secondPriceLabel = XGSLabel(textAlignment: .left, fontSize: 15, weight: .regular)
    let gamePassLabel = XGSBadgeLabel(type: .whiteGamePass)
    let goldLabel = XGSBadgeLabel(type: .gold)
    
    var exchangeRate: Double = 1.0
    var currencySymbol = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(deal: Deal, currencySymbol: String, exchangeRate: Double) {
        coverImageView.downloadImage(fromURL: deal.imageUrl)
        gamePassLabel.isHidden = !deal.availableInGamePass
        goldLabel.isHidden = !deal.discountWithGold
        titleLabel.text = deal.title
        
        self.currencySymbol = currencySymbol
        self.exchangeRate = exchangeRate
    }
    
    private func configure() {
        addSubviews(coverImageView, titleLabel, currentPriceLabel, secondPriceLabel, gamePassLabel, goldLabel)
        
        backgroundColor = K.Colors.cardColor
        layer.cornerRadius = 10

        titleLabel.numberOfLines = 3

        goldLabel.font = .systemFont(ofSize: 10, weight: .black)
        
        secondPriceLabel.textColor = .secondaryLabel
                
        let padding: CGFloat = 10
        let textPadding: CGFloat = 5
        let textHeight: CGFloat = 18
        let badgeHeight: CGFloat = 20
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor),
            
            gamePassLabel.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: -padding),
            gamePassLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -padding),
            gamePassLabel.heightAnchor.constraint(equalToConstant: badgeHeight),
            
            goldLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: padding),
            goldLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: padding),
            goldLabel.heightAnchor.constraint(equalToConstant: badgeHeight),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            currentPriceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textPadding),
            currentPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            currentPriceLabel.heightAnchor.constraint(equalToConstant: textHeight),
            
            secondPriceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textPadding),
            secondPriceLabel.leadingAnchor.constraint(equalTo: currentPriceLabel.trailingAnchor, constant: textPadding),
            secondPriceLabel.heightAnchor.constraint(equalToConstant: textHeight)
        ])
    }
}
