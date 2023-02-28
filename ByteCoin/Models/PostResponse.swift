//
//  PostResponse.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 22.02.2023.
//

struct PostResponse: Decodable {

    let userId: Int
    var id: Int
    let title: String
    let body: String
}
