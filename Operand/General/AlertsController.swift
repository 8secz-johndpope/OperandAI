//
//  AlertsController.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-14.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    // MARK: Server Communications
    
    /// Displays an error message to user as an UIAlertAction
    /// - Parameter title: Title string of alert (will be bolded)
    /// - Parameter message: Message string of alert description
    func displayAlertForUser(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /// Displays an internal server error message to user as an UIAlertAction
    /// - Remark: Will display title **Error**, and message: "An internal server error occured."
    func displayInternalServerErrorDialog() {
        self.displayAlertForUser(title: "Error", message: "An internal server error occured.")
    }
    
    /// Displays a server connection error message to user as an UIAlertAction
    /// - Remark: Will display title **Error**, and message: "A connection to the server cannot be established."
    func displayServerConnectionErrorDialog() {
        self.displayAlertForUser(title: "Error", message: "A connection to the server cannot be established.")
    }
}
