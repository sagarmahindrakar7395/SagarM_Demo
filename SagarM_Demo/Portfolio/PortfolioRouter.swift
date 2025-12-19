//
//  PortfolioRouter.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation
import UIKit

final class PortfolioRouter: PortfolioRouterProtocol {

    static func createModule() -> UIViewController {
        let view = PortfolioViewController()
        let presenter = PortfolioPresenter()
        let interactor = PortfolioInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view
    }
}


