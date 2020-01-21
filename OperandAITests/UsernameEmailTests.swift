//
//  OperandAITests.swift
//  OperandAITests
//
//  Created by Nirosh Ratnarajah on 2019-12-18.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import XCTest
@testable import OperandAI

class UsernameEmailTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidUsername() {
        
        XCTAssertTrue(isValidUsername(username: "John Doe"))
        XCTAssertTrue(isValidUsername(username: "John D"))
    }
    
    func testInvalidUsername() {
        
        XCTAssertFalse(isValidUsername(username: "This Name Is Too Long to be Valid"))
        XCTAssertFalse(isValidUsername(username: "I have an @"))
        XCTAssertFalse(isValidUsername(username: "test@test.com"))
    }
    
    func testValidEmail() {
        
        XCTAssertTrue(isValidEmail(email: "email@example.com"))
        XCTAssertTrue(isValidEmail(email: "firstname.lastname@example.com"))
        XCTAssertTrue(isValidEmail(email: "email@subdomain.example.com"))
        XCTAssertTrue(isValidEmail(email: "firstname+lastname@example.com"))
        XCTAssertTrue(isValidEmail(email: "email@123.123.123.123"))
        XCTAssertTrue(isValidEmail(email: "email@[123.123.123.123]"))
        XCTAssertTrue(isValidEmail(email: "\"email\"@example.com"))
        XCTAssertTrue(isValidEmail(email: "1234567890@example.com"))
        XCTAssertTrue(isValidEmail(email: "email@example-one.com"))
        XCTAssertTrue(isValidEmail(email: "_______@example.com"))
        XCTAssertTrue(isValidEmail(email: "email@example.name"))
        XCTAssertTrue(isValidEmail(email: "email@example.museum"))
        XCTAssertTrue(isValidEmail(email: "email@example.co.jp"))
        XCTAssertTrue(isValidEmail(email: "firstname-lastname@example.com"))
        XCTAssertTrue(isValidEmail(email: "email@example.web"))
        XCTAssertTrue(isValidEmail(email: "email@111.222.333.44444"))
    }
    
    func testInvalidEmail() {
        
        XCTAssertFalse(isValidEmail(email: "plainaddress"))
        XCTAssertFalse(isValidEmail(email: "#@%^%#$@#$@#.com"))
        XCTAssertFalse(isValidEmail(email: "@example.com"))
        XCTAssertFalse(isValidEmail(email: "Joe Smith <email@example.com>"))
        XCTAssertFalse(isValidEmail(email: "email.example.com"))
        XCTAssertFalse(isValidEmail(email: "email@example@example.com"))
        XCTAssertFalse(isValidEmail(email: ".email@example.com"))
        XCTAssertFalse(isValidEmail(email: "email.@example.com"))
        XCTAssertFalse(isValidEmail(email: "email..email@example.com"))
        XCTAssertFalse(isValidEmail(email: "あいうえお@example.com"))
        XCTAssertFalse(isValidEmail(email: "email@example.com (Joe Smith)"))
        XCTAssertFalse(isValidEmail(email: "email@example"))
        XCTAssertFalse(isValidEmail(email: "email@-example.com"))
        XCTAssertFalse(isValidEmail(email: "email@example..com"))
        XCTAssertFalse(isValidEmail(email: "Abc..123@example.com"))
        
        XCTAssertFalse(isValidEmail(email: #"”(),:;<>[\]@example.com"#))
        XCTAssertFalse(isValidEmail(email: "just”not”right@example.com"))
        XCTAssertFalse(isValidEmail(email: "very.unusual.”@”.unusual.com@example.com"))
        XCTAssertFalse(isValidEmail(email: #"this\ is"really"not\allowed@example.com"#))
        XCTAssertFalse(isValidEmail(email: #"much.”more\\ unusual”@example.com"#))
        XCTAssertFalse(isValidEmail(email: "very.unusual.”@”.unusual.com@example.com"))
        XCTAssertFalse(isValidEmail(email: #"very.”(),:;<>[]”.VERY.”very@\\ "very”.unusual@strange.example.com"#))
    }
    
}
