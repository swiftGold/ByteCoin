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
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private var coinManager = CoinManager()
    private var coinViewModel: CoinModel?
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(), jsonDecoderManager: JSONDecoderManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        fetchStartCoin()
    }
    
    @objc
    private func changeCurrencyButtonTapped() {
        print(#function)
    }
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        currencyLabel.text = String(currency + " ")
        fetchCurrencyCoin(currency: currency)
    }
}

private extension MainViewController {
    func fetchCurrencyCoin(currency: String) {
        apiService.fetchCurrencyCoin(currency: currency) { [weak self] result in
            switch result {
                
            case .success(let response):
                let viewModel: CoinModel = .init(quoteId: response.asset_id_quote, rate: response.rate)
                self?.setCostLabel(with: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchStartCoin() {
        apiService.fetchStartCoin { [weak self] result in
            switch result {
                
            case .success(let response):
                let viewModel: CoinModel = .init(quoteId: response.asset_id_quote, rate: response.rate)
                self?.setCostLabel(with: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setCostLabel(with model: CoinModel) {
        DispatchQueue.main.async { [weak self] in
            self?.costLabel.text = "\(model.rateString)"
        }
    }
    
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
        view.addSubview(pickerView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changeCurrencyButton.widthAnchor.constraint(equalToConstant: 80),
            changeCurrencyButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
