//
//  String+Ext.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 30.08.2022.
//

import UIKit


extension String {
    
    func encodeHtmlString() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        return attributedString.string
    }
    
    func firstMatch(regex: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: regex) else { return nil }
        let result  = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return result.map { String(self[Range($0.range, in: self)!]) }.first
    }
    
    func match(regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex) else { return [] }
        let result  = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return result.map {
            return String(self[Range($0.range, in: self)!])
        }
    }
    
    func convertToDouble() -> Double? {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        var formatedString = trimmedString.replacingOccurrences(of: ".", with: "")
        formatedString = formatedString.replacingOccurrences(of: ",", with: ".")
        
        return Double(formatedString)
    }
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
