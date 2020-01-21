//
//  PerformanceTests.swift
//  OperandAITests
//
//  Created by Nirosh Ratnarajah on 2019-12-19.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import XCTest
@testable import OperandAI

class PerformanceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testCurrencyFormatterPerformance() {
        // This is an example of a performance test case.
        measure {
            _ = CurrencyFormatter.formatter
        }
    }
    
    func testCurrentDatePerformance() {
        // This is an example of a performance test case.
        measure {
            _ = CurrentDate.formatter
            _ = CurrentDate.currentDate
        }
    }

}
