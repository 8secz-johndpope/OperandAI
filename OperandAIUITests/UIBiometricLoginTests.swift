//
//  OperandAIUITests.swift
//  OperandAIUITests
//
//  Created by Nirosh Ratnarajah on 2019-12-15.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import XCTest

class UIBiometricLoginTests: XCTestCase {
    
    let app = XCUIApplication()
    
    // Shows permissions alerts over our app
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Biometrics.enrolled()
    }
    
    func test_launchingWithBiometricsDisabled() {
        Biometrics.unenrolled()
        app.launch()
        XCTAssertTrue(app.staticTexts["Biometrics Unavailable"].waitForExistence(timeout: 1))
    }
    
    func test_launchingWithBiometricsEnabled() {
        Biometrics.enrolled()
        app.launch()
        XCTAssertTrue(app.staticTexts["Face ID"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.buttons["Biometric authentication"].isEnabled)
    }
    
    func testBiometricLogin() {
        
        Biometrics.enrolled()
        app.launch()
        XCTAssertTrue(app.staticTexts["Login"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.textFields["Your username or email"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.buttons["Biometric authentication"].waitForExistence(timeout: 1))
        app.buttons["Biometric authentication"].tap()
        sleep(2)
        acceptPermissionsPromptIfRequired()
        Biometrics.successfulAuthentication()
        
        let tabBarsQuery = app.tabBars
        XCTAssertTrue(tabBarsQuery.buttons["Dashboard"].waitForExistence(timeout: 1))
        XCTAssertTrue(tabBarsQuery.buttons["Operand"].waitForExistence(timeout: 1))
        XCTAssertTrue(tabBarsQuery.buttons["Settings"].waitForExistence(timeout: 1))
        
        tabBarsQuery.buttons["Dashboard"].tap()
        let dashboardNavigationBar = app.navigationBars["Dashboard"]
        dashboardNavigationBar.staticTexts["Dashboard"].tap()
        
        let currentDate = Date()
        let test = DateFormatter()
        test.dateStyle = .medium
        test.timeStyle = .none
        XCTAssertTrue(app.navigationBars["Dashboard"].staticTexts[test.string(from: currentDate)].waitForExistence(timeout: 1))
        
        tabBarsQuery.buttons["Operand"].tap()
        XCTAssertTrue(app.navigationBars["Operand"].staticTexts["Operand"].waitForExistence(timeout: 1))
        
        tabBarsQuery.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].staticTexts["Settings"].waitForExistence(timeout: 1))
        
    }
    
    func test_unsuccessfulAuthentication() {
        Biometrics.enrolled()
        app.launch()
        app.buttons["Biometric authentication"].tap()
        acceptPermissionsPromptIfRequired()
        Biometrics.unsuccessfulAuthentication()
        let cancelButton = springboard.alerts.buttons["Cancel"].firstMatch
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.tap()
        XCTAssertTrue(app.staticTexts["Face ID"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.buttons["Biometric authentication"].isEnabled)
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
