//
//  LocalStorage.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-21.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation
import os

let app = OSLog(subsystem: "group.nameless.financials", category: "Local Storage")

// MARK: User Default Keys

private let EmailKey = "localEmail"
private let OnboardedKey = "firstLogin"
private let TokenKey = "localToken"

// MARK: Service Storage

private let FinancialsKey = "financials"
private let FinancialsNotificationKey = "financialsNotification"

// MARK: Getters and Setters

/// User email to be saved
/// - Remark: Setter
/// - Important: Key = localEmail
/// - Parameter email: String type of user's email
func emailLS(email: String) {
    // Only overwrite existing email if email is not empty
    if !email.isEmpty {
        UserDefaults.standard.set(email, forKey: EmailKey)
        os_log(.info, log: app, "Setting local email stored: %{public}@ ", email)
        return
    }
    os_log(.error, log: app, "Failed to set local email stored: <empty email>")
}

/// Retrieve email stored locally
/// - Remark: Getter
/// - Important: Key = localEmail
/// - Returns: String of local email stored
func emailLS() -> String {
    let email = UserDefaults.standard.string(forKey: EmailKey) ?? ""
    os_log(.info, log: app, "Getting local email stored: %{public}@ ", email)
    return email
}

/// Save if financials is enabled for user
/// - Remark: Setter
/// - Important:
///     + Key = financials
///     + Default value is false
/// - Note: True if disabled, due to how the default of the boolean default is created
/// - Parameter financialsDisabled: True if Financials Service is disabled, false otherwise
func financialsLS(financialsDisabled: Bool) {
    UserDefaults.standard.set(financialsDisabled, forKey: FinancialsKey)
    os_log(.info, log: app, "Setting local Financials Service stored: %d", financialsDisabled)
}

/// Save if financials is enabled for user
/// - Remark: Getter
/// - Important:
///     + Key = financials
///     + Default value is false
/// - Note: True if disabled, due to how the default of the boolean default is created
/// - Returns: True if Financials Service is disabled, false otherwise
func financialsLS() -> Bool {
    let financials = UserDefaults.standard.bool(forKey: FinancialsKey)
    os_log(.info, log: app, "Getting local Financials Service state: %d", financials)
    return financials
}

/// Save if financials notifications is enabled for user
/// - Remark: Setter
/// - Important:
///     + Key = financialsNotification
///     + Default value is false
/// - Note: True if disabled, due to how the default of the boolean default is created
/// - Parameter financialsNotificationsDisabled: True if Financials Service notification is disabled, false otherwise
func financialsNotificationLS(financialsNotificationsDisabled: Bool) {
    UserDefaults.standard.set(financialsNotificationsDisabled, forKey: FinancialsNotificationKey)
    os_log(.info, log: app, "Setting local Financials Notification Service stored: %d", financialsNotificationsDisabled)
}

/// Save if financials is enabled for user
/// - Remark: Getter
/// - Important:
///     + Key = financialsNotification
///     + Default value is false
/// - Note: True if disabled, due to how the default of the boolean default is created
/// - Returns: True if Financials Service notification is disabled, false otherwise
func financialsNotificationLS() -> Bool {
    let financialsNotifications = UserDefaults.standard.bool(forKey: FinancialsNotificationKey)
    os_log(.info, log: app, "Getting local Financials Notification Service state: %d", financialsNotifications)
    return financialsNotifications
}

/// Onboarding state set
/// - Remark: Setter
/// - Note: To be used to decide if onboarding view should be shown
/// - Important:
///     + Key = firstLogin
///     + Default value is false
/// - Parameter isOnboarded: True if onboarding complete, false otherwise
func onboardedLS(isOnboarded: Bool) {
    UserDefaults.standard.set(isOnboarded, forKey: OnboardedKey)
    os_log(.info, log: app, "Setting local onboarded stored: %d", isOnboarded)
}

/// Retrieve onboarding state
/// - Remark: Getter
/// - Note: To be used to decide if onboarding view should be shown
/// - Important:
///     + Key = firstLogin
///     + Default value is false
/// - Returns: True if onboarding completed, false otherwise
func onboardedLS() -> Bool {
    let isOnboarded = UserDefaults.standard.bool(forKey: OnboardedKey)
    os_log(.info, log: app, "Getting local onboarded state: %d", isOnboarded)
    return isOnboarded
}

/// Authentication token to be saved
/// - Remark: Setter
/// - Note: To be used login user faster with token validation
/// - Important: Key = localToken
/// - Parameter token: String type returned from server to be stored
func tokenLS(token: String) {
    UserDefaults.standard.set(token, forKey: TokenKey)
    os_log(.info, log: app, "Setting local token stored: %{public}@ ", token)
}

/// Retrieve token stored locally for authentication purposes
/// - Remark: Getter
/// - Note: To be used to login user faster with token validation
/// - Important: Key = localToken
/// - Returns: String of authentication token
func tokenLS() -> String {
    let token = UserDefaults.standard.string(forKey: TokenKey) ?? ""
    os_log(.info, log: app, "Getting local token stored: %{public}@ ", token)
    return token
}

// MARK: Helper Methods

/// Deletes all stored data for user
/// - Important: Changes cannot be reversed
/// - Remark: Default value for onboarded state will become false
func deleteLS() {
    UserDefaults.standard.removeObject(forKey: EmailKey)
    UserDefaults.standard.removeObject(forKey: OnboardedKey)
    UserDefaults.standard.removeObject(forKey: TokenKey)
    os_log(.info, log: app, "User stored data deleted")
}

/// Logs the stored data
/// - Note: Calls all getters, which have their own logging
func logStoredUserLS() {
    _ = emailLS()
    _ = tokenLS()
    _ = onboardedLS()
}
