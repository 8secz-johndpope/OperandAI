//
//  Settings.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-08.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import os
import UIKit

class SettingsVC: UITableViewController {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Settings")
    
    var updateDataDelegate: UpdateDataDeletage? = nil
    
    var list: [SettingsData] = [SettingsData(strings: ["Currently signed in as", "First Last"], endpoint: ProfileVC()),
                                SettingsData(strings: ["Billing", "Active"], endpoint: UIViewController())] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var services: [SettingsData] = [SettingsData(strings: ["Financials", "dollarsign.circle"], endpoint: FinancialsServiceVC())] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let sections = ["", "Services"]
    
    // MARK: View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        os_log(.info, log: self.app, "View did load")
        
        // Group the table view by section
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        // Set navigation bar
        self.title = "Settings"
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
        
        // TO-DO: SERVER CODE to call server to get name of user
        
    }
    
    // MARK: TableView Controller
    
    /// Number of sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
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
            // If the cell links to the ProfileVC we need
            // to set the update data delegate
            if list[indexPath.row].endpoint! is ProfileVC {
                let newVc: ProfileVC = list[indexPath.row].endpoint as! ProfileVC
                newVc.updateDataDelegate = self
                let navigationVC = self.navigationController
                navigationVC!.pushViewController(newVc, animated: true)
                break
            }
            let newVc = list[indexPath.row].endpoint!
            let navigationVC = self.navigationController
            navigationVC!.pushViewController(newVc, animated: true)
        case 1:
            let newVc: UIViewController = services[indexPath.row].endpoint!
            let navigationVC = self.navigationController
            navigationVC!.pushViewController(newVc, animated: true)
        default:
            fatalError("Cell being created in section that doesn't exist")
        }
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Number of section to make
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    /// Number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return list.count
        case 1:
            return services.count
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
            cell.accessoryType = .disclosureIndicator
        case 1:
            let serviceCell = tableView.dequeueReusableCell(withIdentifier: "LeadingIconAndLabelTableCell", for: indexPath) as! LeadingIconAndLabelTableCell
            serviceCell.nameLabel.text = services[indexPath.row].strings[0]
            serviceCell.serviceIcon.image = UIImage(systemName: services[indexPath.row].strings[1])
            serviceCell.accessoryType = .disclosureIndicator
            return serviceCell
        default:
            return cell
        }
        return cell
    }
    
    /// Row cell height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension SettingsVC: UpdateDataDeletage {
    
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
