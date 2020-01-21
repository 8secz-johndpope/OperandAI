//
//  Profile.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-10.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import os
import UIKit

class ProfileVC: UITableViewController {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Profile")
    
    var updateDataDelegate: UpdateDataDeletage? = nil
    
    var list: [SettingsData] = [SettingsData(strings: ["Name", "First Last"], endpoint: EditProfileVC()),
                                SettingsData(strings: ["Email", "hello@operand.ai"], endpoint: EditProfileVC()),
                                SettingsData(strings: ["Joined", "January 1st, 1970"], endpoint: nil)] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        os_log(.info, log: self.app, "View did load")
        
        // Group the table view by section
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        // Set navigation bar
        self.title = "Profile"
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 20)!]
        
        // Register the cells in this table view
        tableView.register(TwoMainLabelTableCell.self, forCellReuseIdentifier: "TwoMainLabelTableCell")
        tableView.register(LeadingIconAndLabelTableCell.self, forCellReuseIdentifier: "LeadingIconAndLabelTableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        
        // TO-DO: SERVER CODE to call server to get name of user
        
    }
    
    // MARK: TableView Controller
    
    /// Size of row depending on section (Profile vs. Accounts)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Section title view
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        let customFont = interExtraLightBeta(size: 14)
        headerView.textLabel!.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        headerView.tintColor = .secondarySystemBackground
        headerView.textLabel!.textColor = UIColor.label
        headerView.textLabel?.numberOfLines = 0
    }
    
    /// When you select table cell, takes you to appropriate VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section) {
        case 0:
            // If the cell has an endpoint, navigate to the
            // new view controller
            let navigationVC = self.navigationController

            if list[indexPath.row].endpoint is EditProfileVC {
                let newVc = list[indexPath.row].endpoint as! EditProfileVC
                newVc.updateDataDelegate = self
                navigationVC!.pushViewController(newVc, animated: true)
            }
            else if let newVc = list[indexPath.row].endpoint {
                navigationVC!.pushViewController(newVc, animated: true)
            }
        default:
            fatalError("Cell being created in section that doesn't exist")
        }
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return list.count
        default:
            return 0
        }
    }
    
    /// If a Profile or Account load appropriate cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "TwoMainLabelTableCell", for: indexPath) as! TwoMainLabelTableCell
        switch (indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "TwoMainLabelTableCell", for: indexPath) as! TwoMainLabelTableCell
            cell.nameLabel.text = list[indexPath.row].strings[0]
            cell.secondaryLabel.text = list[indexPath.row].strings[1]
            if list[indexPath.row].endpoint != nil {
                cell.accessoryType = .disclosureIndicator
            }
        default:
            return cell
        }
        return cell
    }
    
    /// Row cell height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Brief: Logouts user and takes them to login sreen
    /// Parameters: Touch up event on logout button
    @objc func logoutButtonPressed() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        os_log(.info, log: self.app, "User being logged out")
        
        // Server functionality removed
//        var request: Users_AuthToken = Users_AuthToken()
//        request.authToken = tokenLS()
//
//
//        devalidateTokenRPC(request: request) { (result, status) in
            
//            let parsedResult: ServerResponseHandler = self.serverResponseHandler(status: status)
//
//            if parsedResult.success {
                os_log(.info, log: self.app, "Logging out, token devalidated")
                if self.updateDataDelegate != nil  {
                    os_log(.info, log: self.app, "Update delegate set, and sending logout signal downstream")
                    self.updateDataDelegate?.showLoginScreen(update: true)
                }
//            } else {
//                os_log(.error, log: self.app, "%s", parsedResult.logString)
//            }
//
//        }
        
    }

}

extension ProfileVC: UpdateDataDeletage {
    
    /// Brief: Updates email label only when email is changed
    /// Parameters: The new email passed down through edit email logic
    func emailLabelUpdate(update: String) {
        os_log(.info, log: self.app, "Email label update not meant to be accessed")
    }
    
    /// Brief: Passes prototcol to show login to Tab Bar
    func showLoginScreen(update: Bool) {
        if update {
            if self.updateDataDelegate != nil  {
                os_log(.info, log: self.app, "Sending logout signal via protocol")
                self.updateDataDelegate?.showLoginScreen(update: true)
            }
        }
    }
    
}

