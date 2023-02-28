//
//  APIService.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 21.02.2023.
//

protocol APIServiceProtocol {
    func fetchStartCoin(completion: @escaping (Result<CoinData, Error>) -> Void)
    func fetchCurrencyCoin(currency: String, completion: @escaping (Result<CoinData, Error>) -> Void)
}

final class APIService {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "469824B9-F3B5-489A-84A1-2EA497DF3DBE"
    
    private let networkManager: NetworkManagerProtocol
    private let jsonDecoderManager: JSONDecoderManagerProtocol
    
    init(
        networkManager: NetworkManagerProtocol,
        jsonDecoderManager: JSONDecoderManagerProtocol
    ) {
        self.networkManager = networkManager
        self.jsonDecoderManager = jsonDecoderManager
    }
}

extension APIService: APIServiceProtocol {
    
    func fetchStartCoin(completion: @escaping (Result<CoinData, Error>) -> Void) {
        let urlString = "\(baseURL)/AUD?apikey=\(apiKey)"
      request(urlString: urlString, completion: completion)
    }
    
    func fetchCurrencyCoin(currency: String, completion: @escaping (Result<CoinData, Error>) -> Void) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
      request(urlString: urlString, completion: completion)
    }
}

private extension APIService {
    
    private func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        networkManager.request(urlString) { [weak self] result in
            switch result {
            case .success(let data):
                self?.jsonDecoderManager.decode(data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

