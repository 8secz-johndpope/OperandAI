//
//  TabBar.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-28.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SwiftGRPC
import UIKit
import os

class TabBarVC: UITabBarController {
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Tab Bar")
    
    var isSetup: Bool = false
    
    var validToken: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Load Dashboard.
        let dashboardVC = DashboardVC(collectionViewLayout: UICollectionViewFlowLayout())
        let dashController = UINavigationController(rootViewController: dashboardVC)
        dashController.tabBarItem.title = "Dashboard"
        dashController.tabBarItem.image = UIImage(systemName: "tray")
        
        // Load Operand Chat View.
        let chatVC = OperandChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        let operandChatController = UINavigationController(rootViewController: chatVC)
        operandChatController.tabBarItem.title = "Operand"
        operandChatController.tabBarItem.image = UIImage(systemName: "circle.bottomthird.split")
        
        // Load Settings with update delegate.
        let settingsVC = SettingsVC()
        settingsVC.updateDataDelegate = self
        let settingsController = UINavigationController(rootViewController: settingsVC)
        settingsController.tabBarItem.title = "Settings"
        settingsController.tabBarItem.image = UIImage(systemName: "gear")
        
        viewControllers = [dashController, operandChatController, settingsController]
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !isSetup {
            
            // If there is a user stored in cache, we show them the biometric login.
            // If it is not their first time but no cached user is stored we take them to login view.
            // Otherwise we show them the register view.
            isSetup = true
            let navigationVC = self.navigationController
            
            var newVc: UIViewController = UIViewController()
            let token: String = tokenLS()
            
            // Load our default login controller first.
            newVc = LoginVC()
            navigationVC!.pushViewController(newVc, animated: false)
            
            // If there is no token, we need to identify if this is the
            // first time the app is being launched then load the
            // appropriate authentication view.
            if token.isEmpty {
                os_log(.info, log: self.app, "No token stored")
                if onboardedLS() {
                    newVc = LoginVC()
                } else {
                    newVc =  RegisterVC()
                    os_log(.info, log: self.app, "User sent to register")
                }
                navigationVC!.popViewController(animated: false)
                navigationVC!.pushViewController(newVc, animated: false)
                return
            }
            
            // Server functionality removed
//            var AuthToken: Users_AuthToken = Users_AuthToken()
//            AuthToken.authToken = token
            
            // If we have a valid token, we can take them to Biometric login.
//            verifyAuthenticationTokenRPC(request: AuthToken) { (result, status) in
//                let statusString: String = status.statusMessage ?? "Unknown error"
//                switch status.statusCode {
//                case StatusCode.ok:
//                    os_log(.info, log: self.app, "Authentication token valid: '%{public}@'")
//                    self.validToken = true
//                    newVc = BiometricLoginVC()
//                    os_log(.info, log: self.app, "Biometric login enabled")
//                    navigationVC!.popViewController(animated: false)
//                    navigationVC!.pushViewController(newVc, animated: false)
//                    break
//                default:
//                    os_log(.info, log: self.app, "Biometric login unavailable: '%{public}@'", statusString)
                    if onboardedLS() {
                        newVc = LoginVC()
                    } else {
                        newVc =  RegisterVC()
                        os_log(.info, log: self.app, "User's first time logging in")
                    }
                    navigationVC!.popViewController(animated: false)
                    navigationVC!.pushViewController(newVc, animated: false)
//                    break
                }
//            }
            
            // Server functionality removed
            // App open metric for data collection.
//            newAppOpenMetricRPC { (status) in
//                let statusString: String = status.statusMessage ?? "Unknown error"
//                switch status.statusCode {
//                case StatusCode.ok:
//                    os_log(.info, log: self.app, "Open app metric successful")
//                    break
//                default:
//                    os_log(.info, log: self.app, "Open app metric failed with: '%{public}@'", statusString)
//                    break
//                }
//
//            }
//        }
        
    }
}

extension TabBarVC: UpdateDataDeletage {
    
    func showLoginScreen(update: Bool) {
        
        // If we get a protocol message to show the login screen, we can push the VC
        if update {
            os_log(.info, log: self.app, "Show Login Screen request sent through UpdateDataDelegate protocol")
            var newVc: UIViewController = UIViewController()
            if onboardedLS() {
                newVc = LoginVC()
            } else {
                newVc =  RegisterVC()
                os_log(.info, log: self.app, "User's first time logging in")
            }
            
            let navigationVC = self.navigationController
            navigationVC!.pushViewController(newVc, animated: true)
        }
    }
    
    /// Not used in this view controller
    func emailLabelUpdate(update: String) {
        os_log(.error, log: self.app, "Unauthorized use of emailLabelUpdate of UpdateDataDelegate protocol")
    }
}
