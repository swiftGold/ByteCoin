//
//  NetworkManager.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 21.02.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func request(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkManager {

}

extension NetworkManager: NetworkManagerProtocol {
    func request(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: urlString)!)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                let myError = NSError(domain: "myError domain", code: -123)
                completion(.failure(myError))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}

//
//    private let jsonDecoderManager: JSONDecoderManagerProtocol
//
//    init(jsonDecoderManager: JSONDecoderManagerProtocol) {
//        self.jsonDecoderManager = jsonDecoderManager
//    }

//    func request(completion: @escaping (Result<[PostResponse], Error>) -> Void) {
//
//        let session = URLSession.shared
//        let urlString = "https://jsonplaceholder.typicode.com/posts"
//        let request = URLRequest(url: URL(string: urlString)!)
//        let task = session.dataTask(with: request) { [weak self] data, response, error in
//
//            guard let data = data else {
//                let myError = NSError(domain: "myError domain", code: -123)
//                completion(.failure(myError))
//                return
//            }
//            //берем метод на комплишенах
//            self?.jsonDecoderManager.decode(data, completion: completion)
//        }
//        task.resume()
//    }
