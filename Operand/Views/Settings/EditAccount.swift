//
//  EditAccount.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-26.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import os
import SnapKit
import UIKit

class EditAccountVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Edit Account")
    
    var accountID: String = ""
    
    var titleLabel: UILabel = createTitleLabel(text: "Bank Account Name", textSize: 30, numberOfLines: 0)
    
    var accountNameTextField: UITextField = createTextField_Top(textSize: 16, tag: 0, placeholder: "Bank Account Name", identifier: "Edit Bank Account Name")
    
    var accountTypeTextField: UITextField = createTextField_Bottom(textSize: 16, tag: 0, placeholder: "Account Type", identifier: "Edit Account Name")
    
    var actionButton: BlackButton = createBlackButton(identifier: "Edit Account")
    
    var cancelButton: UIButton = createBlueButton(textSize: 14, text: "Cancel", identifier: "Cancel")
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupSignUpView()
        
        // Get notified when the keyboard is up or down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Notify us when the text field has been populated
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    /// Remove move view up on keyboard appears logic and textfield observer
    deinit {
        os_log(.info, log: self.app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Allow back button to appear but not the whole navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        os_log(.info, log: self.app, "View will disappear, resetting tab bar")
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
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
    
    /// Brief: Dismisses modal view of edit account
    /// Parameters; Touch up event on cancel button
    @objc func cancelEditAccount() {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        os_log(.info, log: self.app, "User canceled request to change account info")
        guard let navigationVC = self.navigationController else { return }
        navigationVC.popViewController(animated: true)
    }
    
    /// If account name text field has text enable the action button
    @objc func defaultsChanged() {
        if accountNameTextField.hasText {
            actionButton.isEnabled = true
        } else {
            actionButton.isEnabled = false
        }
    }
    
    /// Brief: Switches to main application if registration successful
    /// Parameters: Touch up event on change button
    @objc func actionButtonPressed() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        os_log(.info, log: self.app, "User requested change to account info")
        guard let navigationVC = self.navigationController else { return }
        navigationVC.popViewController(animated: true)
        
        guard let newAccountName = accountNameTextField.text else {
            os_log(.fault, log: self.app, "Error unwrapping account name text field.")
            return
        }
        
        if newAccountName.isEmpty {
            os_log(.info, log: self.app, "User tried to save an empty account name")
            self.displayAlertForUser(title: "Error", message: "New account name cannot be empty")
            return
        }
        
        // Server functionality removed
//        var request: Financials_NameEditRequest = Financials_NameEditRequest()
//        request.acctID = accountID
//        request.newName = newAccountName
//        setAuthTokenRPC(token: tokenLS())
//        editAccountNameRPC(request: request) { (empty, status) in
//
//            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if parsedResult.success {
                os_log(.info, log: self.app, "Account named changed")
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
        
        actionButton.isEnabled = accountNameTextField.hasText
        return true
    }
    
    /// Brief: From username textfield, next to password textfield, hit return to hide keyboard
    /// Parameters: Username and password text field delegates
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
    
    /// Brief: Sets the edit account view with SnapKit
    func setupSignUpView() {
        
        // Set background color to user default
        self.view.backgroundColor = .systemBackground
        
        // If the account name has text in it, enable the action button
        self.view.addSubview(accountNameTextField)
        accountNameTextField.delegate = self
        accountNameTextField.returnKeyType = UIReturnKeyType.default
        accountNameTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        accountNameTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                       for: .allEditingEvents)
        accountNameTextField.isEnabled = true
        
        self.view.addSubview(accountTypeTextField)
        accountTypeTextField.delegate = self
        accountTypeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(accountNameTextField.snp.bottom).offset(2.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        accountTypeTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                       for: .allEditingEvents)
        accountTypeTextField.isEnabled = false
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(accountNameTextField.snp.top).offset(-30)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(accountTypeTextField.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(65)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-65)
            make.height.equalTo(35)
        }
        actionButton.isEnabled = false
        actionButton.addTarget(self, action: #selector(self.actionButtonPressed),
                               for: .touchUpInside)
        
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(actionButton.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        cancelButton.addTarget(self, action: #selector(self.cancelEditAccount),
                               for: .touchUpInside)
    }
    
}
