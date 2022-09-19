//
//  AppSettingsManager.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 31.08.2022.
//

import Foundation


class AppSettingsManager {
    
    static let shared = AppSettingsManager()
    var convertToRubles = false {
        didSet {
            save()
        }
    }
    
    private init() {
        load()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(convertToRubles) {
            UserDefaults.standard.set(encoded, forKey: K.SaveKeys.convertToRubles)
        }
    }
    
    func load() {
        if let savedConvertToRubles = UserDefaults.standard.data(forKey: K.SaveKeys.convertToRubles) {
            if let decodedConvertToRubles = try? JSONDecoder().decode(Bool.self, from: savedConvertToRubles) {
                convertToRubles = decodedConvertToRubles
            }
        } else {
            convertToRubles = false
        }
    }
}
