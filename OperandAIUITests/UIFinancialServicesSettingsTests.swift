//
//  UIFinancialServicesSettingsTests.swift
//  OperandAIUITests
//
//  Created by Nirosh Ratnarajah on 2019-12-16.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import XCTest

class UIFinancialServicesSettingsTests: XCTestCase {
    
    let app = XCUIApplication()
    
    // Shows permissions alerts over our app
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    override class func setUp() {
        Biometrics.enrolled()
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        Biometrics.enrolled()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func loadFinancialsSettings() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        app.launch()
        app.buttons["Biometric authentication"].tap()
        sleep(2)
        acceptPermissionsPromptIfRequired()
        Biometrics.successfulAuthentication()
        
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 1))
        app.tabBars.buttons["Settings"].tap()
        
        let tablesQuery = app.tables
        let cellQuery = tablesQuery.cells.containing(.staticText, identifier: "Financials")
        let cell = cellQuery.children(matching: .staticText)
        let cellElement = cell.element
        cellElement.tap()

        let tableElement = tablesQuery.element
        tableElement.swipeUp()

    }
    
    // MARK: Helpers
    
    // Face ID asks the user for permission the first time you try to authenticate. Touch ID doesn't.
    private func acceptPermissionsPromptIfRequired() {
        let permissionsOkayButton = springboard.alerts.buttons["OK"]
        if permissionsOkayButton.exists {
            permissionsOkayButton.tap()
        }
    }

}
