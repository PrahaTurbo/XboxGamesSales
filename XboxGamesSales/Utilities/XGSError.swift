//
//  XGSError.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import Foundation

enum XGSError: Error {
    case invalidUrl, unableToComplete, invalidResponse, invalidData
}

extension XGSError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("Что-то пошло не так и мы не смогли отправить запрос на сервер.", comment: "Invalid URL")
        case .unableToComplete:
            return NSLocalizedString("Что-то пошло не так и мы не смогли отправить запрос на сервер.", comment: "Unable to complete request")
        case .invalidResponse:
            return NSLocalizedString("Мы не смогли связаться с сервером.", comment: "Invalid response from server")
        case .invalidData:
            return NSLocalizedString("У нас не получилось обработать данные с сервера.", comment: "Invalid data")
        }
    }
}
