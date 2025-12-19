//
//  PortfolioContracts.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation
import UIKit

protocol PortfolioViewProtocol: AnyObject {
    func showHoldings(_ holdings: [UserHoldingElement])
    func showSummary(_ summary: PortfolioSummary)
}

protocol PortfolioPresenterProtocol {
    func viewDidLoad()
    func toggleSummary()
}

protocol PortfolioInteractorProtocol {
    func fetchHoldings()
}

protocol PortfolioInteractorOutputProtocol: AnyObject {
    func didFetchHoldings(_ holdings: [UserHoldingElement])
    func didFailFetchingHoldings(_ error: NetworkError)
}


protocol PortfolioRouterProtocol {
    static func createModule() -> UIViewController
}
