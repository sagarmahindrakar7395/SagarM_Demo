//
//  HoldingCell.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import UIKit

final class HoldingCell: UITableViewCell {

    private let symbolLabel = UILabel()
    private let netQtyLabel = UILabel()

    private let ltpLabel = UILabel()
    private let pnlLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none

        symbolLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        symbolLabel.textColor = .label

        netQtyLabel.font = .systemFont(ofSize: 13)
        netQtyLabel.textColor = .secondaryLabel

        ltpLabel.font = .systemFont(ofSize: 14, weight: .medium)
        ltpLabel.textAlignment = .right

        pnlLabel.font = .systemFont(ofSize: 14, weight: .medium)
        pnlLabel.textAlignment = .right

        let leftStack = UIStackView(arrangedSubviews: [symbolLabel, netQtyLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 6
        leftStack.alignment = .leading

        let rightStack = UIStackView(arrangedSubviews: [ltpLabel, pnlLabel])
        rightStack.axis = .vertical
        rightStack.spacing = 6
        rightStack.alignment = .trailing

        contentView.addSubview(leftStack)
        contentView.addSubview(rightStack)

        leftStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            leftStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            leftStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rightStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            leftStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            leftStack.trailingAnchor.constraint(lessThanOrEqualTo: rightStack.leadingAnchor, constant: -12)
        ])
    }

    func configure(_ holding: UserHoldingElement) {

        let quantity = holding.quantity ?? 0
        let ltp = holding.ltp ?? 0
        let avgPrice = holding.avgPrice ?? 0

        let pnl = (ltp - avgPrice) * Double(quantity)

        symbolLabel.text = holding.symbol
        netQtyLabel.text = "NET QTY: \(quantity)"

        ltpLabel.text = String(format: "LTP: ₹%.2f", ltp)
        pnlLabel.text = String(format: "P&L: ₹%.2f", pnl)
        pnlLabel.textColor = pnl >= 0 ? .systemGreen : .systemRed
    }
}

