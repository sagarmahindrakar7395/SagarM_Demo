//
//  PortfolioPresenter.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation

final class PortfolioPresenter: PortfolioPresenterProtocol {

    weak var view: PortfolioViewProtocol?
    var interactor: PortfolioInteractorProtocol?
    var isExpanded = true

    private var holdings: [UserHoldingElement] = []

    func viewDidLoad() {
        interactor?.fetchHoldings()
    }

    func toggleSummary() {
        isExpanded.toggle()
    }

    private func calculateSummary() -> PortfolioSummary {

        let currentValue = holdings.reduce(0) {
            $0 + ((($1.ltp ?? 0) * Double($1.quantity ?? 0)))
        }

        let totalInvestment = holdings.reduce(0) {
            $0 + ((($1.avgPrice ?? 0) * Double($1.quantity ?? 0)))
        }

        let totalPNL = currentValue - totalInvestment

        let todaysPNL = holdings.reduce(0) {
            $0 + (((($1.close ?? 0) - ($1.ltp ?? 0)) * Double($1.quantity ?? 0)))
        }

        return PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPNL: totalPNL,
            todaysPNL: todaysPNL
        )
    }
}

extension PortfolioPresenter: PortfolioInteractorOutputProtocol {
    func didFailFetchingHoldings(_ error: NetworkError) {
        //
    }
    
    func didFetchHoldings(_ holdings: [UserHoldingElement]) {
        self.holdings = holdings
        view?.showHoldings(holdings)
        view?.showSummary(calculateSummary())
    }
}
