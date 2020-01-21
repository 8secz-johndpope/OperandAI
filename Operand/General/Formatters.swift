//
//  CurrentDate.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-21.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation

/// Structure to create the date
struct CurrentDate {
    
    static let currentDate = Date()
    static let formatter = DateFormatter()
}

/// Structure to format currency
struct CurrencyFormatter {
    static let formatter = NumberFormatter()
}
