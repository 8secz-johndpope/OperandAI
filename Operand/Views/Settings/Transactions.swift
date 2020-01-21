//
//  Transactions.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-11-02.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import DJSemiModalViewController
import UIKit
import os

class TransactionsVC: UITableViewController {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Transactions")
    
    var transactions = [TransactionModel]() {
        didSet {
            os_log(.info, log: self.app, "Transactions data changed, reloading")
            self.tableView.reloadData()
        }
    }
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
        
        // Group the table view by section
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        // Set navigation bar
        self.title = "Transactions"
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 20)!]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Adding refresh capabilities for view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload(sender:)), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        
        // Register the stacked cell style
        tableView.register(TwoMainLabelTableCell.self, forCellReuseIdentifier: "TwoMainLabelTableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    // MARK: Action Functions
    
    /// Brief: Reload the transactions data if the user pulls down on the table view
    @IBAction func reload(sender: UIScreenEdgePanGestureRecognizer) {
        
        os_log(.info, log: self.app, "Reloading transactions")
        
        // TO-DO: Implement refresh with server code
        
        refreshControl?.endRefreshing()
        os_log(.info, log: self.app, "Finished reloading transactions")
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

            transactions.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    /// When you select table cell, takes you to appropriate VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        tableView.deselectRow(at: indexPath, animated: true)
        
        os_log(.info, log: self.app, "User tapped transaction: %{public}@, %{public}@, %{public}@,", transactions[indexPath.row].businessName, transactions[indexPath.row].accountName, String(transactions[indexPath.row].amount))
        
        let controller = DJSemiModalViewController()
        controller.automaticallyAdjustsContentHeight = true
        controller.maxWidth = self.view.frame.size.width
        controller.minHeight = 200
        
        // load fonts we need
        let labelFont = interLightBeta(size: 18)
        let titleFont = interSemiBold(size: 18)
        let accountFont = interRegular(size: 20)
        
        // set title
        controller.title = transactions[indexPath.row].businessName
        controller.titleLabel.font = UIFontMetrics.default.scaledFont(for: titleFont)
        controller.titleLabel.numberOfLines = 0
        
        // set all content
        let accountNameLabel = UILabel()
        accountNameLabel.font = UIFontMetrics.default.scaledFont(for: accountFont)
        accountNameLabel.text = transactions[indexPath.row].accountName + "\n"
        accountNameLabel.textAlignment = .center
        accountNameLabel.numberOfLines = 0
        controller.addArrangedSubview(view: accountNameLabel)
        
        let amountLabel = UILabel()
        amountLabel.font = UIFontMetrics.default.scaledFont(for: labelFont)
        let formatter = CurrencyFormatter.formatter
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: transactions[indexPath.row].amount as NSNumber) {
            amountLabel.text = formattedTipAmount + " " + transactions[indexPath.row].currency
        }
        amountLabel.textAlignment = .center
        controller.addArrangedSubview(view: amountLabel)
        
        let dateLabel = UILabel()
        dateLabel.font = UIFontMetrics.default.scaledFont(for: labelFont)
        dateLabel.text = transactions[indexPath.row].date
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 0
        controller.addArrangedSubview(view: dateLabel)
        
        let categoryLabel = UILabel()
        categoryLabel.font = UIFontMetrics.default.scaledFont(for: labelFont)
        categoryLabel.text = transactions[indexPath.row].category
        categoryLabel.textAlignment = .center
        categoryLabel.numberOfLines = 0
        controller.addArrangedSubview(view: categoryLabel)
        
        // if the transaction is pending, load this view
        if transactions[indexPath.row].isPending {
            let pendingLabel = UILabel()
            pendingLabel.font = UIFontMetrics.default.scaledFont(for: labelFont)
            pendingLabel.text = "Pending"
            pendingLabel.textAlignment = .center
            pendingLabel.numberOfLines = 0
            controller.addArrangedSubview(view: pendingLabel)
        }
        
        controller.presentOn(presentingViewController: self, animated: true, onDismiss: { })
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
        switch(section) {
        case 0:
            if transactions.count == 0 {
                tableView.setEmptyView(title: "", message: "No recent transactions.")
            } else {
                tableView.restore()
            }
            return transactions.count
        default:
            return 0
        }
    }
    
    /// If a Profile or Account load appropriate cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoMainLabelTableCell") as! TwoMainLabelTableCell
        switch (indexPath.section) {
        case 0:
            cell.nameLabel.text = transactions[indexPath.row].businessName
            let formatter = CurrencyFormatter.formatter
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: transactions[indexPath.row].amount as NSNumber) {
                cell.secondaryLabel.text = formattedTipAmount
            }
            cell.accessoryType = .disclosureIndicator
        default:
            return cell
        }
        return cell
    }
    
    // MARK: Helper Functions
    
    /// Load extra cells when the user scrolls to the bottom of the table
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            os_log(.info, log: self.app, "User scrolled to the bottom of the table")
        }
    }
    
}
