//
//  Models.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-27.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation
import UIKit

/// Dashboard cell data model
class CellModel {
    var arrowImage: UIImage
    var name: String
    var amount: Double
    var historicalAmount: [Double] = []
    var relevance: Double
    
    init(arrowImage: Bool, name: String, amount: Double, historicalAmount: [Double], relevance: Double) {
        self.arrowImage = ((arrowImage ? UIImage(named: "AppIcon") : UIImage(named: "AppIcon"))!)
        self.name = (name.replacingOccurrences(of: "_", with: " ")).capitalized
        self.amount = amount
        self.historicalAmount += historicalAmount
        self.relevance = relevance
    }
}

/// Transaction model for storing transactions
struct TransactionModel {
    var businessName: String
    var accountName: String
    var amount: Double
    var date: String
    var isPending: Bool
    var category: String
    var currency: String
    
    init(businessName: String, accountName: String, amount: Double, date: String, isPending: Bool, category: String, currency: String) {
        self.businessName = businessName
        self.accountName = accountName
        self.amount = amount
        self.date = date
        self.isPending = isPending
        self.category = category
        self.currency = currency
    }
}

enum RegisteredService: String {
    case FINANCIALS = "FINANCIALS"
    case PASSWORD = "PASSWORD"
}

class DashData {
    
    var header: String?
    var title: String?
    var text: String?
    var relevance: Double?
}

/// Structure to hold settings menu contents neatly
struct SettingsData {
    
    /// Array of strings to hold title and description, or other text
    /// - Remark: Each index must be manually dereferenced
    /// - Important: Programmer must ensure we don't access elements outside range
    var strings: [String]
    
    /// UIViewController endpoint the settings cell points to
    /// - Remark: If no view controller is to be set, **nil** is the suggested entry
    /// - Warning: Make sure to check if endpoint is **nil** before presenting endpoint
    var endpoint: UIViewController?
}
