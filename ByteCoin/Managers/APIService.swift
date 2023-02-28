//
//  APIService.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 21.02.2023.
//

protocol APIServiceProtocol {
    func fetchPosts(completion: @escaping (Result<[PostResponse], Error>) -> Void)
}

final class APIService {
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
    func fetchPosts(completion: @escaping (Result<[PostResponse], Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
      request(urlString: urlString, completion: completion)
    }
    
    func fetchCoin(completion: @escaping (Result<CoinData, Error>) -> Void) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/AUD?apikey=469824B9-F3B5-489A-84A1-2EA497DF3DBE"
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

