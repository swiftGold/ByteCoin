//
//  MainViewController.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 17.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ByteCoin"
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 248), for: .horizontal)
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bitcoinsign.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = UIColor.label
        button.setTitleColor(.green, for: .normal)
        button.addTarget(self, action: #selector(changeCurrencyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.text = "000000"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ByteCoin")
        label.text = "$  "
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemGray3
        stackView.layer.cornerRadius = 40
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 25
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let apiService = APIService(networkManager: NetworkManager(),
                                        jsonDecoderManager: JSONDecoderManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
//        apiService.fetchPosts {[weak self] result in
//            switch result {
//
//            case .success(let response):
//                self?.setupCostLabel(with: response)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        apiService.fetchCoin { [weak self] result in
            switch result {
                
            case .success(let response):
                
                let model: CoinModel = .init(quoteId: response.asset_id_quote, rate: response.rate)
                
                
                self?.setupCostLabel(with: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupCostLabel(with model: CoinModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.costLabel.text = "\(model.rateString)"
        }
    }
    
    @objc
    private func changeCurrencyButtonTapped() {
        print(#function)
    }
}

private extension MainViewController {
    
    func setupViewController() {
        view.backgroundColor = .systemMint
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        currencyStackView.addArrangedSubview(changeCurrencyButton)
        currencyStackView.addArrangedSubview(costLabel)
        currencyStackView.addArrangedSubview(currencyLabel)
        
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(currencyStackView)
        
        view.addSubview(topStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            changeCurrencyButton.widthAnchor.constraint(equalToConstant: 80),
            changeCurrencyButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
