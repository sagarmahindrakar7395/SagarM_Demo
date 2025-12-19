//
//  SagarM_DemoTests.swift
//  SagarM_DemoTests
//
//  Created by APPLE on 12/18/25.
//

import XCTest
@testable import SagarM_Demo

final class SagarM_DemoTests: XCTestCase {


    func testPresenter_toggleSummary_togglesFlag() {
        let presenter = PortfolioPresenter()
        XCTAssertTrue(presenter.isExpanded, "isExpanded should default to true")
        presenter.toggleSummary()
        XCTAssertFalse(presenter.isExpanded, "toggleSummary should flip the flag")
        presenter.toggleSummary()
        XCTAssertTrue(presenter.isExpanded, "toggleSummary should flip the flag back")
    }

    func testPresenter_didFetchHoldings_showsHoldingsAndSummary() {
        let presenter = PortfolioPresenter()
        let mockView = MockPortfolioView()
        presenter.view = mockView

        let holdings: [UserHoldingElement] = [
            UserHoldingElement(symbol: "AAA", quantity: 2, ltp: 10.0, avgPrice: 8.0, close: 11.0),
            UserHoldingElement(symbol: "BBB", quantity: 3, ltp: 20.0, avgPrice: 18.0, close: 22.0)
        ]

        presenter.didFetchHoldings(holdings)

        // Verify holdings forwarded
        XCTAssertEqual(mockView.receivedHoldings?.count, 2)
        XCTAssertEqual(mockView.receivedHoldings?.first?.symbol, "AAA")

        // Verify summary values
        // currentValue = 2*10 + 3*20 = 20 + 60 = 80
        // totalInvestment = 2*8 + 3*18 = 16 + 54 = 70
        // totalPNL = 80 - 70 = 10
        // todaysPNL = ((close - ltp) * qty) => (11-10)*2 + (22-20)*3 = 2 + 6 = 8

        guard let summary = mockView.receivedSummary else {
            XCTFail("Expected a summary to be shown")
            return
        }

        XCTAssertEqual(summary.currentValue, 80)
        XCTAssertEqual(summary.totalInvestment, 70)
        XCTAssertEqual(summary.totalPNL, 10)
        XCTAssertEqual(summary.todaysPNL, 8)
    }

    func testPresenter_viewDidLoad_callsInteractorFetch() {
        let presenter = PortfolioPresenter()
        let mockInteractor = MockInteractor()
        presenter.interactor = mockInteractor

        presenter.viewDidLoad()

        XCTAssertTrue(mockInteractor.fetchHoldingsCalled, "viewDidLoad should call interactor.fetchHoldings")
    }


    func testInteractor_fetchHoldings_success_callsPresenterDidFetchHoldings() {
        let holdings: [UserHoldingElement] = [
            UserHoldingElement(symbol: "AAA", quantity: 1, ltp: 5.0, avgPrice: 4.0, close: 6.0)
        ]

        let userHolding = UserHolding(data: DataClass(userHolding: holdings))
        let mockNetwork = MockNetworkManager(result: .success(userHolding))
        let interactor = PortfolioInteractor(networkManager: mockNetwork)

        let mockPresenter = MockInteractorOutput()
        interactor.presenter = mockPresenter

        let expect = expectation(description: "Presenter didFetchHoldings called")
        mockPresenter.didFetchHoldingsHandler = { received in
            XCTAssertEqual(received.count, holdings.count)
            expect.fulfill()
        }

        interactor.fetchHoldings()

        waitForExpectations(timeout: 1.0)
    }

    func testInteractor_fetchHoldings_failure_callsPresenterDidFail() {
        let mockNetwork = MockNetworkManager(result: .failure(.noData))
        let interactor = PortfolioInteractor(networkManager: mockNetwork)

        let mockPresenter = MockInteractorOutput()
        interactor.presenter = mockPresenter

        let expect = expectation(description: "Presenter didFailFetchingHoldings called")
        mockPresenter.didFailFetchingHoldingsHandler = { error in
            switch error {
            case .noData:
                break
            default:
                XCTFail("Expected NetworkError.noData, got \(error)")
            }
            expect.fulfill()
        }

        interactor.fetchHoldings()

        waitForExpectations(timeout: 1.0)
    }
}

private final class MockPortfolioView: PortfolioViewProtocol {
    var receivedHoldings: [UserHoldingElement]?
    var receivedSummary: PortfolioSummary?

    func showHoldings(_ holdings: [UserHoldingElement]) {
        receivedHoldings = holdings
    }

    func showSummary(_ summary: PortfolioSummary) {
        receivedSummary = summary
    }
}

private final class MockInteractor: PortfolioInteractorProtocol {
    private(set) var fetchHoldingsCalled = false
    func fetchHoldings() {
        fetchHoldingsCalled = true
    }
}

private final class MockInteractorOutput: PortfolioInteractorOutputProtocol {
    var didFetchHoldingsHandler: (([UserHoldingElement]) -> Void)?
    var didFailFetchingHoldingsHandler: ((NetworkError) -> Void)?

    func didFetchHoldings(_ holdings: [UserHoldingElement]) {
        didFetchHoldingsHandler?(holdings)
    }

    func didFailFetchingHoldings(_ error: NetworkError) {
        didFailFetchingHoldingsHandler?(error)
    }
}

private final class MockNetworkManager: NetworkManaging {
    private let result: Result<Any, NetworkError>

    init(result: Result<Any, NetworkError>) {
        self.result = result
    }

    func request<T>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        DispatchQueue.global().async {
            switch self.result {
            case .success(let any):
                if let typed = any as? T {
                    completion(.success(typed))
                } else {
                    completion(.failure(.decodingFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
