//
//  FinancialsService.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-10.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import os
import UIKit

class FinancialsServiceVC: UITableViewController {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Financials Service")
    
    var list: [SettingsData] = [SettingsData(strings: ["Enabled"], endpoint: nil),
                                SettingsData(strings: ["Linked Accounts"], endpoint: AccountsVC()),
                                SettingsData(strings: ["Transactions"], endpoint: TransactionsVC())] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var financialsEnabled: Bool = true {
        didSet {
            os_log(.info, log: self.app, "Refreshing table view on financialsEnabled change")
            
            UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
                self.tableView.reloadData()
            }, completion: nil);
        }
    }
    
    // MARK: View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        os_log(.info, log: self.app, "View did load")
        
        // Group the table view by section
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        // Set navigation bar
        self.title = "Financials"
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 20)!]
        
        // Register the cells in this table view
        tableView.register(TwoMainLabelTableCell.self, forCellReuseIdentifier: "TwoMainLabelTableCell")
        tableView.register(SwitchTableCell.self, forCellReuseIdentifier: "SwitchTableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        financialsEnabled = financialsLS()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
            if let newVc = list[indexPath.row].endpoint {
                let navigationVC = self.navigationController
                navigationVC!.pushViewController(newVc, animated: true)
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Number of section to make
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            if financialsEnabled {
                return 1
            }
            return list.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    /// If a Profile or Account load appropriate cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case 0:
            if list[indexPath.row].endpoint == nil {
                let serviceCell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableCell", for: indexPath) as! SwitchTableCell
                serviceCell.nameLabel.text = list[indexPath.row].strings[0]
                serviceCell.serviceIcon.isOn = !financialsLS()
                serviceCell.serviceIcon.addTarget(self, action: #selector(enableService), for: .touchUpInside)
                return serviceCell
            } else {
                let listCell = tableView.dequeueReusableCell(withIdentifier: "TwoMainLabelTableCell", for: indexPath) as! TwoMainLabelTableCell
                listCell.nameLabel.text = list[indexPath.row].strings[0]
                listCell.secondaryLabel.text = nil
                listCell.accessoryType = .disclosureIndicator
                return listCell
            }
        case 1:
            let serviceCell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableCell", for: indexPath) as! SwitchTableCell
            serviceCell.nameLabel.text = "Notifications"
            serviceCell.serviceIcon.isOn = !financialsNotificationLS()
            serviceCell.serviceIcon.addTarget(self, action: #selector(enableNotification), for: .touchUpInside)
            return serviceCell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "TwoMainLabelTableCell", for: indexPath) as! TwoMainLabelTableCell
        }
    }
    
    @objc func enableService() {
        
        os_log(.info, log: self.app, "Switch pressed")
        
        var currentState: Bool = financialsLS()
        currentState.toggle()
        financialsLS(financialsDisabled: currentState)
        
        financialsEnabled.toggle()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    @objc func enableNotification() {
        
        os_log(.info, log: self.app, "Notification switch pressed")
        
        var currentState: Bool = financialsNotificationLS()
        currentState.toggle()
        financialsNotificationLS(financialsNotificationsDisabled: currentState)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    /// Row cell height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

