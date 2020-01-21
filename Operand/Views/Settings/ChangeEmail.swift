//
//  ChangeEmail.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-11-09.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import UIKit
import os

/// Profile Sign In Screen
class ChangeEmailVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Change Email")
    
    var updateDataDelegate: UpdateDataDeletage? = nil
    
    var titleLabel: UILabel = createTitleLabel(text: "Change Email", textSize: 40, numberOfLines: 0)
    
    var oldEmailTextField: UITextField = createTextField_WellRounded(textSize: 16, tag: 0, placeholder: "Old Email", identifier: "Old Email")
    
    var newEmailTextField: UITextField = createTextField_Top(textSize: 16, tag: 1, placeholder: "New Email", identifier: "Your new email")
    
    var confirmNewEmailField: UITextField = createTextField_Bottom(textSize: 16, tag: 2, placeholder: "Confirm New Email", identifier: "Confirm your new email")
    
    var actionButton: BlackButton = createBlackButton(identifier: "Login")
    
    var switchButton: UIButton = createBlueButton(textSize: 14, text: "Cancel", identifier: "Cancel")
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupSignInView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "View appeared")
        
        // ensure the text is empty in the password field
        oldEmailTextField.text = ""
        newEmailTextField.text = ""
        confirmNewEmailField.text = ""
    }
    
    // MARK: Action Functions
    
    /// Brief: Dismisses change password view
    /// Parameters: Touch up event on switch button
    @objc func dismissView() {
        
        os_log(.info, log: self.app, "Change email being dismissed")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        dismiss(animated: true, completion: nil)
    }
    
    /// Brief: Changes password and dismisses view
    /// Parameters; Touch up event on Login button
    @objc func actionButtonPressed(_ sender: Any) {
        
        os_log(.info, log: self.app, "Attempting to change email")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let newEmail = newEmailTextField.text, isValidEmail(email: newEmail) else {
            os_log(.info, log: self.app, "Invalid new email")
            displayAlertForUser(title: "Error", message: "Invalid new email.")
            return
        }
        
        guard confirmNewEmailValid() else {
            os_log(.info, log: self.app, "New email fields do not match.")
            displayAlertForUser(title: "Error", message: "New email fields do not match.")
            return
        }
        
        guard let oldEmailInput = oldEmailTextField.text else {
            os_log(.fault, log: self.app, "Error unwrapping old email text field text.")
            return
        }
        
        let oldEmail: String = emailLS()
        
        // Server functionality removed
//        var request: Users_EmailUpdateRequest = Users_EmailUpdateRequest()
//        request.authToken = tokenLS()
//        request.newEmail = newEmail
        
        if (oldEmail == oldEmailInput) {
            //            updateEmailRPC(request: request) { (result, status) in
            //
            //                let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
            //
            //                if parsedResult.success {
            //                    os_log(.info, log: self.app, "Changing email successful")
            //                    email(email: email)
            //
            //                    self.dismiss(animated: true, completion: nil)
            //                } else {
            //                    os_log(.error, log: self.app, "%s", parsedResult.logString)
            //                }
            //
            //            }
            
            // TO-DO: Replace with server implentation
            
            if updateDataDelegate != nil {
                updateDataDelegate?.emailLabelUpdate(update: "test@test.com")
            }
            
            
        } else {
            os_log(.info, log: self.app, "Invalid old email")
            displayAlertForUser(title: "Error", message: "Invalid old email.")
            return
        }
        
    }
    
    /// Brief: Checks if the username and password text field is not empty, and enables the login button
    /// Parameter: Username text field delegate and password text field delegate
    /// Return: True
    @objc private func textFieldNotEmpty(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        actionButton.isEnabled = oldEmailTextField.hasText && newEmailTextField.hasText && confirmNewEmailField.hasText
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
    
    /// Brief: Confirms that both passwords match each other
    /// Return: True if both user passwords match, false otherwise
    func confirmNewEmailValid() -> Bool {
        if let newEmail = newEmailTextField.text, let confirmNew = confirmNewEmailField.text {
            return newEmail == confirmNew
        }
        os_log(.fault, log: self.app, "Error unwrapping values of new email text fields")
        return false
    }
    
    /// Brief: Sets the sign in view with SnapKit
    func setupSignInView() {
        
        // Set background color to user default
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(newEmailTextField)
        newEmailTextField.delegate = self
        newEmailTextField.returnKeyType = UIReturnKeyType.next
        newEmailTextField.keyboardType = .emailAddress
        newEmailTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(40)
            
        }
        newEmailTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                    for: .allEditingEvents)
        
        self.view.addSubview(oldEmailTextField)
        oldEmailTextField.delegate = self
        oldEmailTextField.returnKeyType = UIReturnKeyType.next
        oldEmailTextField.keyboardType = .emailAddress
        oldEmailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(newEmailTextField.snp.top).offset(-15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(40)
        }
        oldEmailTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                    for: .allEditingEvents)
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(oldEmailTextField.snp.top).offset(-22.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(confirmNewEmailField)
        confirmNewEmailField.delegate = self
        confirmNewEmailField.returnKeyType = UIReturnKeyType.done
        confirmNewEmailField.keyboardType = .emailAddress
        confirmNewEmailField.snp.makeConstraints { (make) in
            make.top.equalTo(newEmailTextField.snp.bottom).offset(2.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(40)
        }
        confirmNewEmailField.addTarget(self, action: #selector(textFieldNotEmpty),
                                       for: .allEditingEvents)
        
        self.view.addSubview(actionButton)
        actionButton.isEnabled = false
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(confirmNewEmailField.snp.bottom).offset(15)
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
            make.height.equalTo(30)
        }
        switchButton.addTarget(self, action: #selector(self.dismissView),
                               for: .touchUpInside)
        
    }
    
}
