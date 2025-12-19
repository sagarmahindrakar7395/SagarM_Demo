//
//  PortfolioSummaryView.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation
import UIKit

final class PortfolioSummaryView: UIView {

    private let containerView = UIView()
    private let contentStack = UIStackView()

    private let currentValueRow = SummaryRowView(title: "Current value*")
    private let totalInvestmentRow = SummaryRowView(title: "Total investment*")
    private let todaysPNLRow = SummaryRowView(title: "Today's Profit & Loss*")

    private let divider = UIView()

    private let totalPNLRow = SummaryRowView(
        title: "Profit & Loss*",
        showsArrow: true
    )

    private var isExpanded = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray6

        containerView.backgroundColor = .clear

        contentStack.axis = .vertical
        contentStack.spacing = 12

        divider.backgroundColor = .systemGray4
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        contentStack.addArrangedSubview(currentValueRow)
        contentStack.addArrangedSubview(totalInvestmentRow)
        contentStack.addArrangedSubview(todaysPNLRow)
        contentStack.addArrangedSubview(divider)

        addSubview(containerView)
        addSubview(totalPNLRow)

        containerView.addSubview(contentStack)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        totalPNLRow.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // Bottom row (always visible)
            totalPNLRow.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
            totalPNLRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalPNLRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalPNLRow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])

        totalPNLRow.onTap = { [weak self] in
            self?.toggle()
        }
    }

    func configure(summary: PortfolioSummary) {

        currentValueRow.setValue(summary.currentValue)
        totalInvestmentRow.setValue(summary.totalInvestment)
        todaysPNLRow.setValue(summary.todaysPNL)
        totalPNLRow.setValue(summary.totalPNL, percentage: summary.totalPNL / summary.totalInvestment * 100)
    }
    
    private func toggle() {
        isExpanded.toggle()

        UIView.animate(withDuration: 0.50, delay: 0, options: [.curveEaseInOut]) {
            self.containerView.alpha = self.isExpanded ? 1 : 0
            self.containerView.isHidden = !self.isExpanded
            self.totalPNLRow.rotateArrow(expanded: self.isExpanded)
            if !self.isExpanded {
                self.contentStack.removeArrangedSubview(self.currentValueRow)
                self.contentStack.removeArrangedSubview(self.totalInvestmentRow)
                self.contentStack.removeArrangedSubview(self.todaysPNLRow)
                self.contentStack.addArrangedSubview(self.divider)
            } else {
                self.contentStack.addArrangedSubview(self.currentValueRow)
                self.contentStack.addArrangedSubview(self.totalInvestmentRow)
                self.contentStack.addArrangedSubview(self.todaysPNLRow)
                self.contentStack.addArrangedSubview(self.divider)
            }
            self.layoutIfNeeded()
        }
    }
}

final class SummaryRowView: UIView {

    var onTap: (() -> Void)?

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let arrowImageView = UIImageView()

    private let showsArrow: Bool

    init(title: String, showsArrow: Bool = false) {
        self.showsArrow = showsArrow
        super.init(frame: .zero)
        setupUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel

        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.textAlignment = .right

        arrowImageView.image = UIImage(systemName: "chevron.up")
        arrowImageView.tintColor = .secondaryLabel
        arrowImageView.isHidden = !showsArrow

        let stack = UIStackView(arrangedSubviews: [titleLabel, arrowImageView, valueLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16)
        ])

        if showsArrow {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
            addGestureRecognizer(tap)
        }
    }

    func setValue(_ value: Double, percentage: Double? = nil) {
        let sign = value >= 0 ? "" : "-"
        let color: UIColor = value >= 0 ? .systemGreen : .systemRed

        if let percentage {
            valueLabel.text = String(
                format: "%@₹%.2f (%.2f%%)",
                sign,
                abs(value),
                abs(percentage)
            )
        } else {
            valueLabel.text = String(format: "%@₹%.2f", sign, abs(value))
        }

        valueLabel.textColor = color
    }

    func rotateArrow(expanded: Bool) {
        let angle: CGFloat = expanded ? 0 : .pi
        arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
    }

    @objc private func didTap() {
        onTap?()
    }
}
