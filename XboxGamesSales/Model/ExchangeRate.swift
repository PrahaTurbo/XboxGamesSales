//
//  ExchangeRate.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 31.08.2022.
//

import Foundation

struct ExchangeRate: Codable {
    let rates: Rates
}

struct Rates: Codable {
    let ARS: Double
    let TRY: Double
}
