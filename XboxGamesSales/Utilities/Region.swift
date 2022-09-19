//
//  Region.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 06.09.2022.
//

import Foundation

enum Region: String {
    case argentina = "🇦🇷 Аргентина"
    case turkey = "🇹🇷 Турция"
    
    var regionCode: String {
        switch self {
        case .argentina:
            return "ar"
        case .turkey:
            return "tr"
        }
    }
    
    var currencySymbol: String {
        switch self {
        case .argentina:
            return "$"
        case .turkey:
            return "₺"
        }
    }
}
