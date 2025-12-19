//
//  UserHoldingDataModel.swift
//  SagarM_Demo
//
//  Created by APPLE on 12/18/25.
//

import Foundation

struct UserHolding: Codable {
    let data: DataClass?
}

struct DataClass: Codable {
    let userHolding: [UserHoldingElement]?
}

struct UserHoldingElement: Codable {
    let symbol: String?
    let quantity: Int?
    let ltp: Double?
    let avgPrice: Double?
    let close: Double?
}

struct PortfolioSummary {
    let currentValue: Double
    let totalInvestment: Double
    let totalPNL: Double
    let todaysPNL: Double
}
