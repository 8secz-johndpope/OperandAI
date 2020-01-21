//
//  BiometricLogin.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-30.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import LocalAuthentication
import SnapKit
import UIKit
import os

/// Profile Sign In Screen
class BiometricLoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Login")
    var userName: String?
    
    var titleLabel: UILabel = createTitleLabel(text: "Login", textSize: 40, numberOfLines: 0)
    
    var credentialsTextField: UITextField = createTextField_WellRounded(textSize: 16, tag: 0, placeholder: "Your credentials", identifier: "Your username or email")
    
    var switchButton: UIButton = createBlueButton(textSize: 16, text: "Login with credentials", identifier: "Login with password")
    
    let context = LAContext()
    
    // custom action button with biometric type in text as button label name
    var actionButton: BlackButton = {
        let button = BlackButton()
        button.backgroundColor = UIColor.label
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.setTitle("Biometrics Unavailable", for: .normal)
        button.accessibilityIdentifier = "Biometric authentication"
        button.titleLabel?.font =  UIFont(name: "Inter-LightBETA", size: 15)
        button.setTitleColor(UIColor.systemGray3, for: .normal)
        button.setTitleColor(UIColor.systemGray3.withAlphaComponent(0.5), for: .highlighted)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "View did load")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupBiometricLoginView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        os_log(.info, log: self.app, "View will appear")
        credentialsTextField.text = emailLS()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: Action Functions
    
    /// Brief: Switches to Register view
    /// Parameters; Touch up event on switch button
    @objc func switchLoginSignup() {
        
        os_log(.info, log: self.app, "Switching to LoginVC")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Set email text field of the Login VC to the
        // credentials text field.
        let newVc: LoginVC = LoginVC()
        newVc.credentialsTextField.text = credentialsTextField.text
        guard let navigationVC = self.navigationController else { return }
        navigationVC.popViewController(animated: false)
        navigationVC.pushViewController(newVc, animated: false)
    }
    
    /// Brief: Switches to main application if login successful
    /// Parameters: Touch up event on Biometric button
    @objc func actionButtonPressed() {
        
        os_log(.info, log: self.app, "Attempting to login via biometrics")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Biometric authentication, if successful let user into application
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login to Financials") { (result, error) in
                if result {
                    os_log(.default, log: self.app, "User being logged in with biometrics")
                    DispatchQueue.main.async {
                        
                        let navigationVC = self.navigationController
                        navigationVC!.popViewController(animated: true)
                    }
                } else {
                    os_log(.default, log: self.app, "User's biometric authentication attempt failed")
                }
            }
        }
    }
    
    // MARK: Helper Functions
    
    /// Brief: Sets the sign in view with SnapKit
    func setupBiometricLoginView() {
        
        // Set background colour to user default.
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(credentialsTextField)
        credentialsTextField.delegate = self
        credentialsTextField.isEnabled = false
        credentialsTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(40)
            
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(credentialsTextField.snp.top).offset(-22.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(credentialsTextField.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(65)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-65)
            make.height.equalTo(35)
        }
        actionButton.addTarget(self, action: #selector(self.actionButtonPressed),
                               for: .touchUpInside)
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: nil) {
            
            if (context.biometryType == LABiometryType.faceID) {
                actionButton.isEnabled = true
                actionButton.setTitle("Face ID", for: .normal)
            } else if context.biometryType == LABiometryType.touchID {
                actionButton.isEnabled = true
                actionButton.setTitle("Touch ID", for: .normal)
            } else {
                os_log(.info, log: self.app, "Biometrics not enabled on device")
                actionButton.isEnabled = false
                actionButton.setTitle("Biometrics Unavailable", for: .normal)
            }
        }
        
        self.view.addSubview(switchButton)
        switchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(actionButton.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.height.equalTo(35)
        }
        switchButton.addTarget(self, action: #selector(self.switchLoginSignup),
                               for: .touchUpInside)
        
    }
    
}

