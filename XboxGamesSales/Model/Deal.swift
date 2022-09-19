//
//  Deal.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import Foundation

struct Deal: Hashable {
    let title: String
    let imageUrl: String?
    let currentPrice: Double
    let goldPrice: Double
    let oldPrice: Double
    let endDateOfDiscount: Date?
    let discountWithGold: Bool
    let availableInGamePass: Bool
    let url: String
}
