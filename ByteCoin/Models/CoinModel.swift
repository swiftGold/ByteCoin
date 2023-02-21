//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 17.02.2023.
//

struct CoinModel {
    let quoteId: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%0.3f", rate)
    }
}
