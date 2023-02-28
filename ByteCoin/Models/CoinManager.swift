//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 17.02.2023.
//

import Foundation

protocol CoinManagerDelegate: AnyObject {
    func didFailWithError(error: Error)
    func didUpdateCurrency(with model: CoinModel)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "469824B9-F3B5-489A-84A1-2EA497DF3DBE"
    
    weak var delegate: CoinManagerDelegate?
    
    func fetchStartCoinCurrency() {
        let urlString = "\(baseURL)/AUD?apikey=\(apiKey)"
        print(urlString)
        performRequest(urlString: urlString)
    }
//    "https://rest.coinapi.io/v1/exchangerate/BTC/AUD?apikey=469824B9-F3B5-489A-84A1-2EA497DF3DBE"
    func fetchCoinCurrency(currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1.Create a URL
        guard let url = URL(string: urlString) else { fatalError() }
        //2. Create a URLsession
        let session = URLSession(configuration: .default)
        //3. Give the session a task
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }

            if let safeData = data {
                if let coin = self.parseJSON(coinData: safeData) {
                    self.delegate?.didUpdateCurrency(with: coin)
                }
            }
        }
        //4. Start the task
        task.resume()
    }

    func parseJSON(coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let idQuote = decodedData.asset_id_quote
            let rate = decodedData.rate

            let coin = CoinModel(quoteId: idQuote, rate: rate)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
