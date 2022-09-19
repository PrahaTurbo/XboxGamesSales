//
//  XGSGameInfoHeaderVC.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 11.09.2022.
//

import UIKit

class XGSHeaderView: UIView {

    let coverImageView = XGSImageView(frame: .zero)
    let titleLabel = XGSLabel(textAlignment: .left, fontSize: 18, weight: .bold)
    let gamePassLabel = XGSBadgeLabel(type: .blackGamePass)

    var deal: Deal
    
    init(deal: Deal) {
        self.deal = deal
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(coverImageView, titleLabel, gamePassLabel)
        
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
        coverImageView.downloadImage(fromURL: deal.imageUrl)
        titleLabel.text = deal.title
        gamePassLabel.isHidden = !deal.availableInGamePass
    }
    
    private func layoutUI() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            coverImageView.heightAnchor.constraint(equalToConstant: 120),
            coverImageView.widthAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            gamePassLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            gamePassLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            gamePassLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
