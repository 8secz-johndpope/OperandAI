//
//  EmailVerification.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-11-13.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import UIKit
import os

/// Profile Sign In Screen
class EmailVerificationVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Email Verification")
    
    var titleLabel: UILabel = createTitleLabel(text: "Verify Email", textSize: 40, numberOfLines: 0)
    
    var tokenTextField: UITextField = createTextField_WellRounded(textSize: 16, tag: 0, placeholder: "Token", identifier: "Token")
    
    var actionButton: BlackButton = createBlackButton(identifier: "Login")
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "View did load")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Setup the view
        setupEmailVerificationView()
        
        // Notify us when the keyboard is up or down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Notify us when the text field has been populated
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        // If the token field has text in it, enable the action button
        tokenTextField.text = tokenLS()
        if tokenTextField.hasText {
            actionButton.isEnabled = true;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        os_log(.info, log: self.app, "View will appear")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /// Remove move view up when keyboard appears logic
    deinit {
        os_log(.info, log: self.app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
    
    /// If the magic link from the email has populated the token text field enable the action button
    @objc func defaultsChanged() {
        os_log(.info, log: self.app, "Received token and emplacing into textfield")
        let token = tokenLS()
        tokenTextField.text = token
        actionButton.isEnabled = true
    }
    
    /// Move keyboard up when needed
    @objc func keyboardWillShow(notification: NSNotification) {
        
        os_log(.info, log: self.app, "View moved to accomodate keyboard")
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.cgRectValue.height*0.1
        }
    }
    
    /// Bring keyboard back to normal position
    @objc func keyboardWillHide(notification: NSNotification) {
        os_log(.info, log: self.app, "View reset while keyboard retracts")
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    /// Brief: Switches to main application if login successful
    /// Parameters; Touch up event on Login button
    @objc func actionButtonPressed() {
        
        os_log(.info, log: self.app, "Attempting to verify email with token")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
//        guard let loginCode = tokenTextField.text else {
//            os_log(.fault, log: self.app, "Error unwrapping token text field")
//            return
//        }
        
        // Server functionality removed
        // Populate Login Code Exchange request
//        var request: Users_LoginCodeExchangeRequest = Users_LoginCodeExchangeRequest()
//        request.loginCode = loginCode
//
//        exchangeLoginCodeRPC(request: request) { (token, status) in
//
//            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if parsedResult.success {
//                os_log(.info, log: self.app, "Email verified, logging in")
//
//                // We will still allow the user to go to the main
//                // application even if we cannot unwrap the token
//                if let safeToken = token {
//                    // Set the token for the user and the Financials service
//                    tokenLS(token: safeToken.authToken)
//                    setAuthTokenRPC(token: safeToken.authToken)
//                }
//
                let navigationVC = self.navigationController
                navigationVC!.popViewController(animated: true)
//            } else {
//                os_log(.error, log: self.app, "%s", parsedResult.logString)
//            }
//            
//        }
    }
    
    /// Brief: Checks if the username and password text field is not empty, and enables the login button
    /// Parameter: Username text field delegate and password text field delegate
    /// Return: True
    @objc private func textFieldNotEmpty(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        actionButton.isEnabled = tokenTextField.hasText
        return true
    }
    
    /// Brief: From username textfield, next to password textfield, hit return to hide keyboard
    /// Parameters: Username and password text field delegates
    /// Return: Bool value, not paticular
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: Helper Functions
    
    /// Brief: Sets the sign in view with SnapKit
    func setupEmailVerificationView() {
        
        // Set background colour to user default.
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(tokenTextField)
        tokenTextField.delegate = self
        tokenTextField.returnKeyType = UIReturnKeyType.done
        tokenTextField.keyboardType = .default
        tokenTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
            
        }
        tokenTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                 for: .allEditingEvents)
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(tokenTextField.snp.top).offset(-22.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(actionButton)
        actionButton.isEnabled = false
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(tokenTextField.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(65)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-65)
            make.height.equalTo(35)
        }
        actionButton.addTarget(self, action: #selector(self.actionButtonPressed),
                               for: .touchUpInside)
        
    }
    
}

