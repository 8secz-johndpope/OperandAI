//
//  Accounts.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-25.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import LinkKit
import os
import UIKit

class AccountsVC: UITableViewController {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Accounts")
    
    // Server functionality removed
//    var accounts = Financials_AccountsList() {
//        didSet {
//            os_log(.info, log: self.app, "Accounts data changed, reloading")
//            self.tableView.reloadData()
//        }
//    }
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
        
        // Group the table view by section
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        // Set navigation bar
        self.title = "Linked Accounts"
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 20)!]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlaidAccount))
        
        // Adding refresh capabilities for view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload(sender:)), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        
        // Register the stacked cell style
        tableView.register(StackedLeadingLabelTableCell.self, forCellReuseIdentifier: "StackedLeadingLabelTableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Server functionality removed
//        setAuthTokenRPC(token: tokenLS())
//        listAccountsRPC { (accounts, status) in
//
//            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if parsedResult.success {
//                // Ensure that the return value is not an empty optional
//                guard let tmpAccounts = accounts else {
//                    self.displayAlertForUser(title: "Error parsing accounts", message: "Try again later.")
//                    return
//                }
//                self.accounts = tmpAccounts
//            } else {
//                os_log(.error, log: self.app, "%s", parsedResult.logString)
//            }
//
//        }
        
    }
    
    /// Size of row depending on section (Profile vs. Accounts)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Allow ability to edit a row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Delete a cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            os_log(.info, log: self.app, "Deleting cell at indexPath: %d", indexPath.row)
            
//            accounts.summaries.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    /// When you select table cell, takes you to appropriate VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Server functionality removed
//        switch (indexPath.section) {
//        case 0:
//            // Setup the edit account view
//            let newVc: EditAccountVC = EditAccountVC()
//            newVc.accountNameTextField.text = accounts.summaries[indexPath.row].name
//            let titleLabel: String = accounts.summaries[indexPath.row].officialName
//            if titleLabel.isEmpty {
//                newVc.titleLabel.text = "Account: " + accounts.summaries[indexPath.row].name
//            } else {
//                newVc.titleLabel.text = titleLabel
//            }
//            newVc.accountTypeTextField.text = accounts.summaries[indexPath.row].type.capitalized
//            newVc.accountID = accounts.summaries[indexPath.row].id
//            let navigationVC = self.navigationController
//            navigationVC!.pushViewController(newVc, animated: true)
//        default:
//            fatalError("Cell being created in section that doesn't exist")
//        }
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Size of section row
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Number of section to make
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Server functionality removed
//        switch(section) {
//        case 0:
//            if accounts.summaries.count == 0 {
                tableView.setEmptyView(title: "", message: "Add your accounts to get started with Financials.")
//            } else {
//                tableView.restore()
//            }
//            return accounts.summaries.count
//        default:
            return 0
//        }
    }
    
    /// If a Profile or Account load appropriate cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackedLeadingLabelTableCell") as! StackedLeadingLabelTableCell
//        switch (indexPath.section) {
//        case 0:
//            cell.nameLabel.text = accounts.summaries[indexPath.row].name
//            cell.secondaryLabel.text = accounts.summaries[indexPath.row].type.capitalized
//            cell.accessoryType = .detailDisclosureButton
//        default:
//            return cell
//        }
        return cell
    }
    
    // MARK: Action Functions
    
    /// Brief: Take user to Plaid screen
    @objc private func addPlaidAccount() {
        
        os_log(.info, log: self.app, "User attempting to add Plaid account")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Present the Plaid controller.
        let vc = PLKPlaidLinkViewController(delegate: self)
        vc.modalPresentationStyle = .automatic
        
        self.present(vc, animated: true, completion: nil)
    }
    
    /// Brief: Reload the table view if user pulls down on table view
    @IBAction func reload(sender: UIScreenEdgePanGestureRecognizer) {
        
        os_log(.info, log: self.app, "Reloading table view")
        
//        setAuthTokenRPC(token: tokenLS())
//        listAccountsRPC { (accounts, status) in
//
//
//            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if parsedResult.success {
//                // Ensure that the return value is not an empty optional
//                guard let tmpAccounts = accounts else {
//                    self.displayAlertForUser(title: "Error parsing accounts", message: "Try again later.")
//                    return
//                }
//                self.accounts = tmpAccounts
//            } else {
//                os_log(.error, log: self.app, "%s", parsedResult.logString)
//            }
//
//        }
        self.refreshControl?.endRefreshing()
    }

}

/// Plaid logic
extension AccountsVC: PLKPlaidLinkViewDelegate {
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        os_log(.info, log: self.app, "Plaid public token: '%{public}@'", publicToken)
//
//        var request: Financials_PublicToken = Financials_PublicToken()
//        request.token = publicToken
//
//        setAuthTokenRPC(token: tokenLS())
//        exchangePublicTokenRPC(request: request) { (empty, status) in
//
//
//            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if parsedResult.success {
//                // If Plaid account linked successfully, we can run the reloading
//                // action to give a nice animation and reload the tableview.
//                self.reload(sender: UIScreenEdgePanGestureRecognizer())
//            } else {
//                os_log(.error, log: self.app, "%s", parsedResult.logString)
//            }
//
//        }
//
        self.dismiss(animated: true, completion: nil)
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        os_log(.fault, log: self.app, "Plaid Link View Controller: %{public}@", error?.localizedDescription ?? "<error>")
        self.dismiss(animated: true, completion: nil)
    }
}
