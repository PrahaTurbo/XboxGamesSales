//
//  Double+Ext.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 14.09.2022.
//

import Foundation

extension Double {
    
    func exchange(_ rate: Double) -> String {
        return String(format: "%.2f", self / rate)
    }
}
