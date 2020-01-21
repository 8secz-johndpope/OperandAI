//
//  ServerResponseHandler.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-14.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation
import os
import SwiftGRPC

struct ServerResponseHandler {
    let success: Bool
    let logString: String
}

extension UIViewController {

    /// Handles server response in switch statement.
    /// - Attention: This method shows an alert for the user. Do not use if you don't want an alert.
    /// - Parameter status: Call result from gRPC call
    /// - Returns: Server Response Handler structure
    ///     + success: true if StatusCode.ok, false otherwise
    ///     + logString: a string to be logged in case of error
    func serverResponseHandler(status: CallResult) -> ServerResponseHandler {
        
        let statusString: String = status.statusMessage ?? "Unknown error"
        switch status.statusCode {
        case StatusCode.ok:
            return ServerResponseHandler(success: true, logString: "success")
        case StatusCode.notFound:
            self.displayAlertForUser(title: "Error", message: statusString)
            return ServerResponseHandler(success: false, logString: "Not Found: " + statusString)
        case StatusCode.failedPrecondition:
            self.displayAlertForUser(title: "Error", message: statusString)
            return ServerResponseHandler(success: false, logString: "Failed Precondition: " + statusString)
        case StatusCode.permissionDenied:
            self.displayAlertForUser(title: "Error", message: statusString)
            return ServerResponseHandler(success: false, logString: "Permission Denied: " + statusString)
        case StatusCode.resourceExhausted:
            self.displayAlertForUser(title: "Error", message: statusString)
            return ServerResponseHandler(success: false, logString: "Resource Exhausted: " + statusString)
        case StatusCode.alreadyExists:
            self.displayAlertForUser(title: "Error", message: statusString)
            return ServerResponseHandler(success: false, logString: "Already Exists: " + statusString)
        case StatusCode.invalidArgument:
            self.displayAlertForUser(title: "Error", message: statusString)
            return ServerResponseHandler(success: false, logString: "Invalid Argument: " + statusString)
        default:
            self.displayInternalServerErrorDialog()
            return ServerResponseHandler(success: false, logString: "Server status code uncaught: " + statusString)
        }
    }
    

}
