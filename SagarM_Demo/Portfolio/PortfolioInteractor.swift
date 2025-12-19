//
//  PortfolioInteractor.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation

final class PortfolioInteractor: PortfolioInteractorProtocol {

    weak var presenter: PortfolioInteractorOutputProtocol?

    private let networkManager: NetworkManaging

    init(
        networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager    }

    func fetchHoldings() {

        let urlString = Constants.url.portfolioURL

        networkManager.request(urlString: urlString) { [weak self]
            (result: Result<UserHolding, NetworkError>) in

            guard let self else { return }

            DispatchQueue.main.async {
                switch result {

                case .success(let response):
                    let holdings = response.data?.userHolding ?? []
                    self.presenter?.didFetchHoldings(holdings)

                case .failure:
                        self.presenter?.didFailFetchingHoldings(.noData)
                }
            }
        }
    }
}

