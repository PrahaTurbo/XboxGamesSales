//
//  NetworkManager.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://psprices.com"
    let cache = NSCache<NSString, UIImage>()
        
    private init() { }
    
    func getDeals(region: Region, page: Int, complition: @escaping (Result<[Deal], XGSError>) -> Void) {
        let endpoint = baseURL + "/region-\(region.regionCode)/collection/most-wanted-deals?platform=XOne&sort=subscribers&ordering=desc&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            complition(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let _ = error {
                complition(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                complition(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                complition(.failure(.invalidData))
                return
            }
            
            let deals = self.scrapeDeals(fromHtml: htmlString)
            complition(.success(deals))
        }
        
        task.resume()
    }
    
    func getLastPageNumber(region: Region, complition: @escaping (Result<Int, XGSError>) -> Void) {
        let endpoint = baseURL + "/region-\(region.regionCode)/collection/most-wanted-deals?platform=XOne&sort=subscribers&ordering=desc&page=1"
        
        guard let url = URL(string: endpoint) else {
            complition(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                complition(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                complition(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                complition(.failure(.invalidData))
                return
            }
            
            if let lastPageNumber = htmlString.match(regex: "(?<=&page=)\\d*(?=\">)").compactMap({ Int($0) }).last {
                complition(.success(lastPageNumber))
            } else {
                complition(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getExchangeRate(complition: @escaping (Result<ExchangeRate, XGSError>) -> Void) {
        let endpoint = "https://api.exchangerate.host/latest?base=RUB"
        
        guard let url = URL(string: endpoint) else {
            complition(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                complition(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                complition(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                complition(.failure(.invalidData))
                return
            }
            
            do {
                let rate = try JSONDecoder().decode(ExchangeRate.self, from: data)
                complition(.success(rate))
            } catch {
                complition(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getGameInfo(from urlString: String, complition: @escaping (Result<GameInfo, XGSError>) -> Void) {
        guard let url = URL(string: urlString) else {
            complition(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let _ = error {
                complition(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                complition(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8)  else {
                complition(.failure(.invalidData))
                return
            }
            
            if let gameInfo = self.scrapeGameInfo(fromHtml: htmlString) {
                complition(.success(gameInfo))
            } else {
                complition(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, complition: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            complition(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            complition(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                complition(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            complition(image)
        }
        
        task.resume()
    }
    
    
    private func scrapeDeals(fromHtml htmlString: String) -> [Deal] {
        var deals = [Deal]()
        let gameCards = htmlString.match(regex: "<div class=\"component--game-card(.*)<")
        
        for card in gameCards {
            let title = card.firstMatch(regex: "(?<=name&quot;:&quot;)(.*?)(?=&quot;)")
            let imageUrl = card.firstMatch(regex: "https:(.*?)(?=&quot;)")?.encodeHtmlString()
            let currentPrice = card.firstMatch(regex: "(?<=price&quot;:&quot;\\W)\\s*[0-9]+\\W*[0-9]*\\W*[0-9]*(?=&quot)")
            let oldPrice = card.firstMatch(regex: "(?<=price_old&quot;:&quot;\\W)\\s*[0-9]+\\W*[0-9]*\\W*[0-9]*(?=&quot)")
            let goldPrice = card.firstMatch(regex: "(?<=price_plus&quot;:&quot;\\W)\\s*[0-9]+\\W*[0-9]*\\W*[0-9]*(?=&quot)")
            let endDate = card.firstMatch(regex: "(?<=end_date&quot;:&quot;)(.*?)(?=&quot;)")
            let availableInGamePass = card.contains("game_pass")
            let url = card.firstMatch(regex: "(?<=url&quot;:&quot;).*?(?=&quot;)")
            
            if let title = title,
               let currentPrice = currentPrice?.convertToDouble(),
               let oldPrice = oldPrice?.convertToDouble(),
               let goldPrice = goldPrice?.convertToDouble(),
               let url = url {
                deals.append(
                    Deal(title: title.encodeHtmlString() ?? title,
                         imageUrl: imageUrl,
                         currentPrice: currentPrice,
                         goldPrice: goldPrice,
                         oldPrice: oldPrice,
                         endDateOfDiscount: endDate?.convertToDate(),
                         discountWithGold: currentPrice != goldPrice,
                         availableInGamePass: availableInGamePass,
                         url: baseURL + url)
                )
            }
        }
        
        return deals
    }
    
    private func scrapeGameInfo(fromHtml htmlString: String) -> GameInfo? {
        let storeUrl = htmlString.firstMatch(regex: "/game/buy/\\d*")
        let screenshotUrls = htmlString.match(regex: "(?<=data-src=\"//).*?(?=\")").map { "https://" + $0 }
        
        guard let storeUrl = storeUrl else  { return nil }
        
        return GameInfo(storeUrl: baseURL + storeUrl, screenshotUrls: screenshotUrls)
    }
}
