//
//  PortfolioViewController.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation
import UIKit

final class PortfolioViewController: UIViewController {

    var presenter: PortfolioPresenterProtocol!

    private let tableView = UITableView()
    private let summaryView = PortfolioSummaryView()

    private var holdings: [UserHoldingElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSummaryView()
        setupTableView()

        presenter.viewDidLoad()
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupSummaryView() {
        view.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //tableView.topAnchor.constraint(equalTo: view.safeAreaInsets.top),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor)
        ])
        //self.tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0);

        tableView.register(HoldingCell.self, forCellReuseIdentifier: Constants.cells.HoldingCell)
        tableView.dataSource = self

        setupTableHeader()
    }
    
    private func setupTableHeader() {
        let headerView = PortfolioHeaderView(
            frame: CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: 100
        )
        )

        tableView.tableHeaderView = headerView
    }
}

extension PortfolioViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holdings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.HoldingCell,for: indexPath) as! HoldingCell
        cell.configure(holdings[indexPath.row])
        return cell
    }
}


extension PortfolioViewController: PortfolioViewProtocol {

    func showHoldings(_ holdings: [UserHoldingElement]) {
        self.holdings = holdings
        tableView.reloadData()
    }

    func showSummary(_ summary: PortfolioSummary) {
        summaryView.configure(summary: summary)
    }
}
