//
//  EditProfile.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-06.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import SwiftGRPC
import UIKit
import os

class EditProfileVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Edit Profile")
    
    var updateDataDelegate: UpdateDataDeletage? = nil
    
    var titleLabel: UILabel = createTitleLabel(text: "Edit Profile", textSize: 30, numberOfLines: 0)
    
    var originalName: String = "Nirosh Ratnarajah"
    
    var profileNameTextField: UITextField = createTextField_Top(textSize: 16, tag: 0, placeholder: "Full Name", identifier: "Full Name")
    
    var profileEmailTextField: UITextField = createTextField_Bottom(textSize: 16, tag: 1, placeholder: "Your Email", identifier: "Your Email")
    
    var actionButton: BlackButton = createBlackButton(identifier: "Edit Profile")
    
    var changeEmailButton: UIButton = createBlueButton(textSize: 16, text: "Change Email", identifier: "Change Email")
    
    var deleteProfileButton: UIButton = createRedButton(textSize: 14, text: "Delete Account", identifier: "Delete Account")
    
    var logoutButton: UIButton = createBlueButton(textSize: 16, text: "Logout", identifier: "Logout")
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupSignUpView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        os_log(.info, log: self.app, "Ready to be presented")
        
        // TO-DO: Change this to what the server gives us
        profileEmailTextField.text = emailLS()
        profileNameTextField.text = originalName
        
        // Allow back button to appear but not the whole navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
    }
    
    /// Remove move view up on keyboard appears logic
    deinit {
        os_log(.info, log: self.app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.updateDataDelegate != nil  {
            self.updateDataDelegate?.emailLabelUpdate(update: emailLS())
        }
        
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
    
    /// Brief: Show change password view
    /// Parameters: Touch up event on change password button
    @objc func changeEmailPressed() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        os_log(.info, log: self.app, "User requests to change email")
        
        let newVc: ChangeEmailVC = ChangeEmailVC()
        newVc.updateDataDelegate = self
        present(newVc, animated: true, completion: nil)
    }
    
    /// Brief: Switches to main application if registration successful
    /// Parameters: Touch up event on change button
    @objc func actionButtonPressed() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // TO-DO: Add server functionality for changing name
        // Unwrapping our profile name text field and then checking if we need to change it
        if let newName = profileNameTextField.text, !newName.isEmpty && newName != originalName {
            os_log(.info, log: self.app, "Updating user's name from %s to %s", originalName, newName)
        }
        
        os_log(.info, log: self.app, "User leaving Edit Profile Controller")
        let navigationVC = self.navigationController
        navigationVC!.popViewController(animated: true)
    }
    
    /// Brief: Switches to main application if registration successful
    /// Parameters: Touch up event on delete profile button
    @objc func deleteButtonPressed() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertController = UIAlertController(title: "Delete your Nameless profile?", message: "This will affect all Nameless products you have. You cannot revert this action.", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Permanently Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            
            let ac = UIAlertController(title: "Enter 'delete' to confirm.", message: nil, preferredStyle: .alert)
            ac.addTextField { (textfield) in
                textfield.placeholder = ""
                textfield.autocorrectionType = .no
                textfield.autocapitalizationType = .none
                textfield.spellCheckingType = .no
                textfield.keyboardType = .emailAddress
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
                
                let text = ac.textFields![0].text ?? ""
                if text != "delete" {
                    return
                }
                
//                var request: Users_AuthToken = Users_AuthToken()
//                request.authToken = tokenLS()
//
//                verifyAuthenticationTokenRPC(request: request) { (token, status) in
//                    let statusString: String = status.statusMessage ?? "Unknown error"
//                    switch status.statusCode {
//                    case StatusCode.ok:
//                        deleteUserRPC(request: request) { (result, status) in
//
//                            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//                            if parsedResult.success {
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                                
                                os_log(.info, log: self.app, "User being deleted")
                                onboardedLS(isOnboarded: false)
                                deleteLS()
                                if self.updateDataDelegate != nil  {
                                    self.updateDataDelegate?.showLoginScreen(update: true)
//                                }
//                            } else {
//                                os_log(.error, log: self.app, "%s", parsedResult.logString)
//                            }
//
//                        }
//                        break
//
//                    default:
//                        os_log(.info, log: self.app, "Failed to authenticate user")
//                        os_log(.info, log: self.app, "Login user failed with: '%{public}@'", statusString)
//                        self.displayAlertForUser(title: "Error", message: "Failed to authenticate")
//                        break
//                    }
//
                }
            }
            
            ac.addAction(submitAction)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                //  Don't need to do anything here
            }))
            
            self.present(ac, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Don't need to do anything here
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Brief: Checks if the username and password text field is not empty, and enables the login button
    /// Parameter: Username text field delegate and password text field delegate
    /// Return: True
    @objc private func textFieldNotEmpty(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        actionButton.isEnabled = profileNameTextField.hasText
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
    func setupSignUpView() {
        
        // Set background color to user default
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(profileEmailTextField)
        profileEmailTextField.delegate = self
        profileEmailTextField.returnKeyType = UIReturnKeyType.next
        profileEmailTextField.isEnabled = false
        profileEmailTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        // Disable predictive text
        profileEmailTextField.textContentType = .oneTimeCode
        profileEmailTextField.keyboardType = .emailAddress
        profileEmailTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                        for: .allEditingEvents)
        
        self.view.addSubview(profileNameTextField)
        profileNameTextField.delegate = self
        profileNameTextField.returnKeyType = UIReturnKeyType.next
        profileNameTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileEmailTextField.snp.top).offset(-2.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        profileNameTextField.textContentType = .oneTimeCode
        profileNameTextField.keyboardType = .asciiCapable
        profileNameTextField.autocapitalizationType = .words
        profileNameTextField.addTarget(self, action: #selector(textFieldNotEmpty),
                                       for: .allEditingEvents)
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileNameTextField.snp.top).offset(-30)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(profileEmailTextField.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(65)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-65)
            make.height.equalTo(35)
        }
        actionButton.isEnabled = true
        actionButton.addTarget(self, action: #selector(self.actionButtonPressed),
                               for: .touchUpInside)
        
        self.view.addSubview(changeEmailButton)
        changeEmailButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(actionButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.greaterThanOrEqualTo(30)
        }
        changeEmailButton.addTarget(self, action: #selector(self.changeEmailPressed),
                                    for: .touchUpInside)
        
        self.view.addSubview(deleteProfileButton)
        deleteProfileButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.equalTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        deleteProfileButton.addTarget(self, action: #selector(self.deleteButtonPressed),
                                      for: .touchUpInside)
        
    }
    
}

extension EditProfileVC: UpdateDataDeletage {
    
    /// Brief: Updates email label only when email is changed
    /// Parameters: The new email passed down through edit email logic
    func emailLabelUpdate(update: String) {
        os_log(.info, log: self.app, "UpdateDataDelegate: email label update %{public}@", update)
        profileEmailTextField.text = update
    }
    
    /// Brief: Not used in this view controller
    func showLoginScreen(update: Bool) {
        os_log(.error, log: self.app, "UpdateDataDelegate: show login screen unauthorized %{public}@", update)
        // Do nothing
    }
    
}
