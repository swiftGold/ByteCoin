//
//  JSONDecoderManager.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 21.02.2023.
//

import Foundation

protocol JSONDecoderManagerProtocol {
    func decode<T: Decodable>(_ data: Data) -> T?
    func decode<T: Decodable>(_ data: Data, completion: @escaping (Result<T, Error>) -> Void)
}

final class JSONDecoderManager {
    private let decoder = JSONDecoder()
}

extension JSONDecoderManager: JSONDecoderManagerProtocol {
    func decode<T: Decodable>(_ data: Data) -> T? {
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print(error, error.localizedDescription)
            return nil
        }
    }
    
    func decode<T: Decodable>(_ data: Data, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
