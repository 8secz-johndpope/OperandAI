//
//  NewDashboard.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-27.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import os
import SnapKit
import UIKit

class DashboardVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Dashboard")
    
    var subtitleLabel: UILabel = {
        let customFont = interSemiBold(size: 15)
        var label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        
        let currentDate = CurrentDate.currentDate
        let test = CurrentDate.formatter
        test.dateStyle = .medium
        test.timeStyle = .none
        
        label.text = test.string(from: currentDate)
        
        return label
    }()
        
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
                
        self.title = "Dashboard"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.hidesBarsOnSwipe = false
        
        // We need to ensure there are no navigation buttons
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        // Set background color
        self.view.backgroundColor = .systemBackground
        
        // Set the collection view and register to cell
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(DashboardCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.alwaysBounceVertical = true
        
        setupTestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        os_log(.info, log: self.app, "View will be dismissed, removing date UIView")
        subtitleLabel.removeFromSuperview()
    }
    
    // MARK: Helper Functions
    
    /// Setup navigation bar properly
    func setupNavigationBar() {
        
        // Add date subtitle to view
        self.navigationController?.navigationBar.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.navigationController!.navigationBar).offset(20)
            make.width.equalTo(self.navigationController!.navigationBar)
            make.top.equalTo(self.navigationController!.navigationBar).offset(20)
        }
        
        // Set Dashboard title to be large by default
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 20)!, .foregroundColor: UIColor.label]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 35)!,.foregroundColor: UIColor.label]
        navBarAppearance.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true);
        
    }
    
    // MARK: Variables
    
    var messages: [DashData]? {
        didSet {
            os_log(.info, log: self.app, "Messages loaded and sorted")
            messages = messages?.sorted(by: {$0.relevance! > $1.relevance!})
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TO-DO: Add code to take user to a detailed VC and add cell highlight feature
        
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // We should always expect to have message loaded from the server
        // Only exception is if server communication fails
        if let count = messages?.count {
            os_log(.info, log: self.app, "%d messages loaded into view", count)
            return count
        }
        
        os_log(.info, log: self.app, "No messages not loaded into view")
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! DashboardCell
        
        if let message = messages?[indexPath.item], let messageText = message.text, let messageHeader = message.header, let messageTitle = message.title {
            
            // Set cell's message contents, including Title, Header, and main Message text
            cell.message = message
            
            // Set the space required for the cell message text
            let contextSize = CGSize(width: view.frame.width - 60, height: 1000)
            let contextOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let contextCustomFont = interLightBeta(size: 16)
            let contextEstimatedFrame = NSString(string: messageText).boundingRect(with: contextSize, options: contextOptions, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: contextCustomFont)], context: nil)
            
            // Set the space required for the cell header
            let headerSize = CGSize(width: view.frame.width - 58, height: 1000)
            let headerOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let headerCustomFont = interSemiBold(size: 14)
            let headerEstimatedFrame = NSString(string: messageHeader).boundingRect(with: headerSize, options: headerOptions, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: headerCustomFont)], context: nil)
            
            // Set the space required for the title
            let titleSize = CGSize(width: view.frame.width - 64, height: 1000)
            let titleOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let titleCustomFont = interRegular(size: 20)
            let titleEstimatedFrame = NSString(string: messageTitle).boundingRect(with: titleSize, options: titleOptions, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: titleCustomFont)], context: nil)
            
            // Allocate the frame size of the title, header, and message text
            cell.headerTextView.frame = CGRect(x: 24, y: 10, width: view.frame.width - 48, height: headerEstimatedFrame.height + 15)
            cell.titleTextView.frame = CGRect(x: 24, y: headerEstimatedFrame.height + 15, width: view.frame.width - 48, height: titleEstimatedFrame.height + 20)
            cell.messageTextView.frame = CGRect(x: 24, y: headerEstimatedFrame.height + 15 + titleEstimatedFrame.height + 20, width: view.frame.width - 48, height: contextEstimatedFrame.height + 30)
            
            // Set the main bubble around to be big enough for the heights we specified before this
            let textBubbleHeight = headerEstimatedFrame.height + 15 + titleEstimatedFrame.height + 20 + contextEstimatedFrame.height + 30
            cell.textBubbleView.frame = CGRect(x: 16, y: 0, width: view.frame.width - 32, height: textBubbleHeight)

            // Set the cell's colours to a classy look
            cell.textBubbleView.backgroundColor = .tertiarySystemGroupedBackground
            cell.messageTextView.textColor = .label
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.row].text, let messageHeader = messages?[indexPath.row].header, let messageTitle = messages?[indexPath.row].title {
            
            // Set the space required for the cell message text
            let contextSize = CGSize(width: view.frame.width - 60, height: 1000)
            let contextOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let contextCustomFont = interLightBeta(size: 16)
            let contextEstimatedFrame = NSString(string: messageText).boundingRect(with: contextSize, options: contextOptions, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: contextCustomFont)], context: nil)
            
            // Set the space required for the cell header
            let headerSize = CGSize(width: view.frame.width - 58, height: 1000)
            let headerOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let headerCustomFont = interSemiBold(size: 14)
            let headerEstimatedFrame = NSString(string: messageHeader).boundingRect(with: headerSize, options: headerOptions, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: headerCustomFont)], context: nil)
            
            // Set the space required for the title
            let titleSize = CGSize(width: view.frame.width - 64, height: 1000)
            let titleOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let titleCustomFont = interRegular(size: 20)
            let titleEstimatedFrame = NSString(string: messageTitle).boundingRect(with: titleSize, options: titleOptions, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: titleCustomFont)], context: nil)
            
            // Set the main bubble around to be big enough for the heights we specified before this
            return CGSize(width: view.frame.width, height: headerEstimatedFrame.height + 15 + titleEstimatedFrame.height + 20 + contextEstimatedFrame.height + 30)
        }
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Add padding at the top between the very first message and the navigation bar
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }

    // TO-DO: Remove this test data and implement server loading content in ViewWillAppear and refresh
    func setupTestData() {
        let message: DashData = DashData()
        message.header = "Financials"
        message.title = "Credit Card Payment. Credit Card Payment. Credit Card Payment. This is an"
        message.relevance = 0.1
        message.text = "TESTING 0.1. Hello my name is Nirosh. This is an even longer message cause yeah why not."
        
        let message2: DashData = DashData()
        message2.header = "Financials"
        message2.title = "0.9"
        message2.relevance = 0.9
        message2.text = "TESTING 0.9. Hello my name is Nirosh. This is an even longer message cause yeah why not. Hello my name is Nirosh. This is an even longer message cause yeah why not."
        
        let message3: DashData = DashData()
        message3.header = "Financials"
        message3.title = "Credit Card Payment"
        message3.relevance = 0.6
        message3.text = "TESTING 0.6. Hello my name is Nirosh. This is an even longer message cause yeah why not."
        
        let message5: DashData = DashData()
        message5.header = "Financials"
        message5.title = "Credit Card Payment"
        message5.relevance = 0.05
        message5.text = "TESTING 0.05. Hello my name is Nirosh. This is an even longer message cause yeah why not."
        
        let message4: DashData = DashData()
        message4.header = "Financials"
        message4.title = "Credit Card Payment"
        message4.relevance = 0.7
        message4.text = "TESTING 0.7. Hello my name is Nirosh. This is an even longer message cause yeah why not yeah not."
        
        messages = [message, message2, message3, message4, message5/*, message, message2, message3, message4, message5, message, message2, message3, message4, message5*/]
    }
    
}
