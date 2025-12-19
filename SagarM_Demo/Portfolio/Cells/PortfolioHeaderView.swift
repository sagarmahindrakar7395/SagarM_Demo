//
//  PortfolioHeaderView.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation
import UIKit

protocol PortfolioHeaderViewDelegate: AnyObject {
    func didSelect(tab: PortfolioHeaderView.Tab)
}

final class PortfolioHeaderView: UIView {

    enum Tab {
        case positions
        case holdings
    }

    weak var delegate: PortfolioHeaderViewDelegate?

    private let contentContainerView = PortfolioTitleView()

    private let tabsContainerView = UIView()


    private let positionsButton = UIButton(type: .system)
    private let holdingsButton = UIButton(type: .system)
    private let underlineView = UIView()

    private var selectedTab: Tab = .holdings


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainers()
        setupTabsUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }


    private func setupContainers() {
        backgroundColor = .white

        addSubview(contentContainerView)
        addSubview(tabsContainerView)

        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        tabsContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabsContainerView.topAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            tabsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabsContainerView.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    private func setupTabsUI() {

        positionsButton.setTitle("POSITIONS", for: .normal)
        holdingsButton.setTitle("HOLDINGS", for: .normal)

        [positionsButton, holdingsButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            $0.setTitleColor(.systemGray, for: .normal)
        }

        positionsButton.addTarget(self, action: #selector(positionsTapped), for: .touchUpInside)
        holdingsButton.addTarget(self, action: #selector(holdingsTapped), for: .touchUpInside)

        underlineView.backgroundColor = .lightGray

        let stack = UIStackView(arrangedSubviews: [positionsButton, holdingsButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually

        tabsContainerView.addSubview(stack)
        tabsContainerView.addSubview(underlineView)

        stack.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: tabsContainerView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: tabsContainerView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: tabsContainerView.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 44),

            underlineView.bottomAnchor.constraint(equalTo: tabsContainerView.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1),
            underlineView.widthAnchor.constraint(equalTo: tabsContainerView.widthAnchor, multiplier: 0.5),
            underlineView.leadingAnchor.constraint(equalTo: tabsContainerView.leadingAnchor)
        ])
        
        select(tab: .holdings, animated: true)
    }


    private func select(tab: Tab, animated: Bool) {
        selectedTab = tab

        let selectedButton = tab == .positions ? positionsButton : holdingsButton
        let deselectedButton = tab == .positions ? holdingsButton : positionsButton

        selectedButton.setTitleColor(.label, for: .normal)
        selectedButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)

        deselectedButton.setTitleColor(.systemGray, for: .normal)
        deselectedButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

        let underlineX = tab == .positions ? 0 : bounds.width / 2

        let animations = {
            self.underlineView.frame.origin.x = underlineX
        }

        animated
        ? UIView.animate(withDuration: 0.25, animations: animations)
        : animations()
    }


    @objc private func positionsTapped() {
        guard selectedTab != .positions else { return }
        select(tab: .positions, animated: true)
        delegate?.didSelect(tab: .positions)
    }

    @objc private func holdingsTapped() {
        guard selectedTab != .holdings else { return }
        select(tab: .holdings, animated: true)
        delegate?.didSelect(tab: .holdings)
    }
}


final class PortfolioTitleView: UIView {

    private let profileImageView = UIImageView()
    private let titleLabel = UILabel()

    private let sortButton = UIButton(type: .system)
    private let searchButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 17/255, green: 52/255, blue: 94/255, alpha: 1)

        profileImageView.image = UIImage(systemName: "person.circle")
        profileImageView.tintColor = .white
        profileImageView.contentMode = .scaleAspectFit

        titleLabel.text = "Portfolio"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white

        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        sortButton.tintColor = .white

        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white

        let leftStack = UIStackView(arrangedSubviews: [profileImageView, titleLabel])
        leftStack.axis = .horizontal
        leftStack.spacing = 8
        leftStack.alignment = .center

        let rightStack = UIStackView(arrangedSubviews: [sortButton, searchButton])
        rightStack.axis = .horizontal
        rightStack.spacing = 16
        rightStack.alignment = .center

        addSubview(leftStack)
        addSubview(rightStack)

        leftStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 28),
            profileImageView.heightAnchor.constraint(equalToConstant: 28),

            leftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            rightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
