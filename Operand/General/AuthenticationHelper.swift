//
//  AuthenticationHelper.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-14.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation

/// Validates if username is acceptable.
/// - Attention:
///     + 6-20 characters long
///     + no _ or . at the beginning or end
///     + no __ or _. or ._ or .. inside
/// - Parameter username: Unencrypted username string.
/// - Returns: True if the username is valid, false otherwise.
func isValidUsername(username: String) -> Bool {
    
    let usernameRegEx = "(?<! )[-a-zA-Z' ]{2,26}"
    let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
    return usernamePred.evaluate(with: username)
}

/// Validates user's email.
/// - Attention: RFC 5322 compliant regex,
/// - Parameter email: Unencrypted email string.
/// - Returns: True if the email is valid, false otherwise.
func isValidEmail(email: String) -> Bool {
    
    let emailReg = #"""
(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])
"""#
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailReg)
    return emailPred.evaluate(with: email)
}
