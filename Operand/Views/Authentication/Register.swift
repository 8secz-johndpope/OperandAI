//
//  Register.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-21.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import UIKit
import os

/// Profile Sign Up Screen
class RegisterVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Register")
    
    var titleLabel: UILabel = {
        
        let customFont = interRegular(size: 40)
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Register for \nNameless Financials"
        return label
    }()
    
    var subtitleLabel: UILabel = {
        
        let customFont = interRegular(size: 17)
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Piece of mind starts here."
        label.textAlignment = .center
        return label
    }()
    
    var fullNameTextField: UITextField = createTextField_Top(textSize: 16, tag: 0, placeholder: "Your full name", identifier: "Your name")
    
    var emailTextField: UITextField = createTextField_Bottom(textSize: 16, tag: 1, placeholder: "Your email", identifier: "Your new email")
    
    var actionButton: BlackButton = createBlackButton(identifier: "Register")
    
    var switchButton: UIButton = createBlueButton(textSize: 14, text: "Already have a Nameless account?", identifier: "Already have a Nameless account? Login")
    
    // MARK: Override Functions
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        // If this is the first load, show OnboardingVC
        if !onboardedLS() {
            let vc: OnboardingVC = OnboardingVC()
            present(vc, animated: true, completion: {
                vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            })
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupRegisterView()
        
        // Notify us when the keyboard is up or down
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Remove the move view up when keyboard appears logic
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
    
    /// Brief: Switches to Login view
    /// Parameters; Touch up event on switch button
    @objc func switchLoginSignup() {
        
        os_log(.info, log: self.app, "Switching to LoginVC")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let profileSignIn: LoginVC = LoginVC()
        profileSignIn.credentialsTextField.text = emailTextField.text
        let navigationVC = self.navigationController
        navigationVC!.popViewController(animated: false)
        navigationVC!.pushViewController(profileSignIn, animated: false)
    }
    
    /// Brief: Switches to main application if registration successful
    /// Parameters: Touch up event on Register button
    @objc func actionButtonPressed() {
        
        os_log(.info, log: self.app, "Attempting to register new user")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Validate name of user
        guard let username = fullNameTextField.text, isValidUsername(username: username) else {
            os_log(.info, log: self.app, "Invalid name entered")
            displayAlertForUser(title: "Error", message: "Invalid Username.")
            return
        }
        
        // Validate email to prevent any scripts
        guard let email = emailTextField.text, isValidEmail(email: email) else {
            os_log(.info, log: self.app, "Invalid email entered")
            displayAlertForUser(title: "Error", message: "Invalid Email.")
            return
        }
        
        // Reset token stored on device
        tokenLS(token: "")
        
        // Server functionality removed
        // Populate the Register User Request
//        var request: Users_RegisterUserRequest = Users_RegisterUserRequest()
//        request.name = username
//        request.email = email
//
//        // Send gRPC request
//        registerRPC(request: request) { (result, status) in
            
//            let registerResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if registerResult.success {
                os_log(.info, log: self.app, "User registered successfully")
                os_log(.info, log: self.app, "New user registered")
                
                // Send out the login code request
//                var requestToken: Users_LoginCodeRequest = Users_LoginCodeRequest()
//                requestToken.email = email
//
//                generateLoginCodeRPC(request: requestToken) { (empty, status) in
//
//                    let codeGenerationResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//                    if codeGenerationResult.success {
//                        // Save the email and token
                        emailLS(email: email)
                        tokenLS(token: "")
                        
                        // Move to email verification view controller
                        let navigationVC = self.navigationController
                        navigationVC!.popViewController(animated: false)
                        navigationVC!.pushViewController(EmailVerificationVC(), animated: true)
//                    } else {
//                        os_log(.error, log: self.app, "%s", codeGenerationResult.logString)
//                    }
//                }
//
//            } else {
//                os_log(.error, log: self.app, "%s", registerResult.logString)
//            }
//        }
        
    }
    
    /// Brief: Checks if the username and password text field is not empty, and enables the login button
    /// Parameter: Username text field delegate and password text field delegate
    /// Return: True
    @objc private func textFieldNotEmpty(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        actionButton.isEnabled = fullNameTextField.hasText && emailTextField.hasText
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
    func setupRegisterView() {
        
        // Set background colour to user settings
        self.view.backgroundColor = .systemBackground
        
        // Make emailTextField target the textFieldNotEmpty
        // to know when to enable action button
        self.view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        // Disable predictive text
        emailTextField.textContentType = .oneTimeCode
        emailTextField.keyboardType = .emailAddress
        emailTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                 for: .allEditingEvents)
        
        self.view.addSubview(fullNameTextField)
        fullNameTextField.delegate = self
        fullNameTextField.returnKeyType = UIReturnKeyType.next
        fullNameTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(emailTextField.snp.top).offset(-2.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        fullNameTextField.textContentType = .oneTimeCode
        fullNameTextField.keyboardType = .asciiCapable
        fullNameTextField.autocapitalizationType = .words
        fullNameTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                    for: .allEditingEvents)
        
        
        self.view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(fullNameTextField.snp.top).offset(-35)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(actionButton)
        actionButton.isEnabled = false
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
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
