//
//  Login.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-21.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import UIKit
import os

/// Profile Sign In Screen
class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Login")
    
    var userName: String?
    
    var titleLabel: UILabel = createTitleLabel(text: "Login", textSize: 40, numberOfLines: 0)
    
    var credentialsTextField: UITextField = createTextField_WellRounded(textSize: 16, tag: 0, placeholder: "Your credentials", identifier: "Your username or email")
    
    var actionButton: BlackButton = createBlackButton(identifier: "Login")
    
    var switchButton: UIButton = createBlueButton(textSize: 14, text: "Don't have an account?", identifier: "Don't have an account? Register")
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "View loaded")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupLoginView()
        
        // Add notification so we know when the keyboard is showing or not.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set the action button to enabled if there is text in the
        // credentials text field when the view is loaded.
        if credentialsTextField.hasText {
            actionButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        os_log(.debug, log: self.app, "View will appear")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /// Remove move view up when keyboard appears logic
    deinit {
        os_log(.info, log: self.app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
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
    
    // MARK: Action Functions
    
    /// Brief: Switches to Register view
    /// Parameters; Touch up event on switch button
    @objc func switchLoginSignup() {
        
        os_log(.info, log: self.app, "Switching to RegisterVC")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Switch to the Register view, setting the email field
        // as the text currently in the credentialsTextField
        let newVc: RegisterVC = RegisterVC()
        newVc.emailTextField.text = credentialsTextField.text
        guard let navigationVC = self.navigationController else { return }
        navigationVC.popViewController(animated: false)
        navigationVC.pushViewController(newVc, animated: false)
    }
    
    /// Brief: Switches to main application if login successful
    /// Parameters; Touch up event on Login button
    @objc func actionButtonPressed() {
        
        os_log(.info, log: self.app, "Attempting to login new user")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Check if the email is valid (no malicious scripts).
        guard let email = credentialsTextField.text, isValidEmail(email: email) else {
            displayAlertForUser(title: "Error", message: "Invalid Email.")
            return
        }
        
        // Reset token stored on device
        tokenLS(token: "")
        
        // Server functionality removed
        // Populate the Login Code Request.
//        var request: Users_LoginCodeRequest = Users_LoginCodeRequest()
//        request.email = email
        
        // Send gRPC request out.
//        generateLoginCodeRPC(request: request) { (empty, status) in
//
//            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if parsedResult.success {
//                // Save the email locally.
//                emailLS(email: email)
//
                // Pop off the Login VC and push the EmailVerificationVC
                os_log(.info, log: self.app, "Sending out verification email")
                let navigationVC = self.navigationController
                navigationVC!.popViewController(animated: false)
                navigationVC!.pushViewController(EmailVerificationVC(), animated: true)
//            } else {
//                os_log(.error, log: self.app, "%s", parsedResult.logString)
//            }
//        }
        
    }
    
    /// Brief: Checks if the username and password text field is not empty, and enables the login button
    /// Parameter: Username text field delegate and password text field delegate
    /// Return: True
    @objc private func textFieldNotEmpty(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        actionButton.isEnabled = credentialsTextField.hasText
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
    func setupLoginView() {
        
        // Set the background colour to the user default
        self.view.backgroundColor = .systemBackground
        
        // Notify the textFieldNotEmpty to enable or disable the action
        // button depending on if there is text in the credentialsTextField.
        self.view.addSubview(credentialsTextField)
        credentialsTextField.delegate = self
        credentialsTextField.returnKeyType = UIReturnKeyType.done
        credentialsTextField.keyboardType = .emailAddress
        credentialsTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
            
        }
        credentialsTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                       for: .allEditingEvents)
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(credentialsTextField.snp.top).offset(-22.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(actionButton)
        actionButton.isEnabled = false
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(credentialsTextField.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(65)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-65)
            make.height.equalTo(35)
        }
        actionButton.addTarget(self, action: #selector(self.actionButtonPressed),
                               for: .touchUpInside)
        
        self.view.addSubview(switchButton)
        switchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(actionButton.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        switchButton.addTarget(self, action: #selector(self.switchLoginSignup),
                               for: .touchUpInside)
        
    }
    
}

