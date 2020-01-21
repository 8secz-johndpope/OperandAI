//
//  Onboarding.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-11.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import UIKit
import os

/// Onboarding Screen for new users
class OnboardingVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Onboarding")
    
    var financialsLabel: UILabel = createOnboardingTitle(font: interBold(size: 50), text: "OperandAI")
    
    var namelessGroupLabel: UILabel = createOnboardingTitle(font: interLightBeta(size: 30), text: "by Nameless Group")
    
    var firstParagraphTitle: UILabel = createOnboardingParagraphTitle(text: "Why Financials?")
    
    var firstParagraph: UILabel = createOnboardingParagraph(text: "Keeping track of all your accounts is hard. Let us help.")
    
    var secondParagraphTitle: UILabel = createOnboardingParagraphTitle(text: "More Personalized")
    
    var secondParagraph: UILabel = createOnboardingParagraph(text: "We have special wizards that compute statistics to keep things personal to you.")
    
    var thirdParagraphTitle: UILabel = createOnboardingParagraphTitle(text: "Security")
    
    var thirdParagraph: UILabel = createOnboardingParagraph(text: "Nameless uses industry leading security, and Plaid to securely access your banks.")
    
    let personImageView: UIImageView = loadImageView(imageName: "OnboardingPersonImage")
    
    let moneyImageView: UIImageView = loadImageView(imageName: "OnboardingMoneyImage")
    
    let lockImageView: UIImageView = loadImageView(imageName: "OnboardingLockImage")
    
    var actionButton: BlackButton = {
        let button = BlackButton()
        button.backgroundColor = UIColor.label
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.setTitle("Next", for: .normal)
        button.accessibilityIdentifier = "Login"
        button.titleLabel?.font =  UIFont(name: "Inter-Regular", size: 18)
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.setTitleColor(UIColor.systemBackground.withAlphaComponent(0.5), for: .highlighted)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.debug, log: self.app, "View did load")
        
        super.viewDidLoad()
        
        // Disallow user to swipe down modal
        // view controller to dismiss Onboarding
        self.isModalInPresentation = true
        
        // Setup view.
        setupOnboardingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.debug, log: self.app, "View will appear")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: Action Functions
    
    /// Brief: Switches to login logic
    /// Parameters: Touch up event on dismiss button
    @objc func actionButtonPressed() {
        
        os_log(.info, log: self.app, "User completed onboarding")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        onboardedLS(isOnboarded: true)
        
        os_log(.info, log: self.app, "Onboarding dismissed")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper Functions
    
    /// Brief: Sets the onboarding view with SnapKit
    func setupOnboardingView() {
        
        // Set background color.
        self.view.backgroundColor = .systemBackground
        
        // Financials title will be the main label.
        self.view.addSubview(financialsLabel)
        financialsLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(65)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(25)
        }
        
        self.view.addSubview(namelessGroupLabel)
        namelessGroupLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(financialsLabel.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(20)
        }
        
        self.view.addSubview(firstParagraphTitle)
        firstParagraphTitle.snp.makeConstraints { (make) in
            make.top.equalTo(namelessGroupLabel.snp.bottom).offset(55)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(-60)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.greaterThanOrEqualTo(20)
        }
        
        self.view.addSubview(moneyImageView)
        moneyImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(firstParagraphTitle.snp.top).offset(5)
            make.right.equalTo(firstParagraphTitle.snp.left).offset(-30)
            make.height.lessThanOrEqualTo(50)
            make.width.lessThanOrEqualTo(60)
        }
        
        self.view.addSubview(firstParagraph)
        firstParagraph.snp.makeConstraints { (make) in
            make.top.equalTo(firstParagraphTitle.snp.bottom).offset(3)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(-60)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.greaterThanOrEqualTo(20)
        }
        
        self.view.addSubview(secondParagraphTitle)
        secondParagraphTitle.snp.makeConstraints { (make) in
            make.top.equalTo(firstParagraph.snp.bottom).offset(30)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(-60)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.greaterThanOrEqualTo(20)
        }
        
        self.view.addSubview(personImageView)
        personImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(secondParagraphTitle.snp.top).offset(5)
            make.right.equalTo(secondParagraphTitle.snp.left).offset(-30)
            make.height.lessThanOrEqualTo(55)
            make.width.lessThanOrEqualTo(55)
        }
        
        self.view.addSubview(secondParagraph)
        secondParagraph.snp.makeConstraints { (make) in
            make.top.equalTo(secondParagraphTitle.snp.bottom).offset(3)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(-60)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.greaterThanOrEqualTo(20)
        }
        
        self.view.addSubview(thirdParagraphTitle)
        thirdParagraphTitle.snp.makeConstraints { (make) in
            make.top.equalTo(secondParagraph.snp.bottom).offset(30)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(-60)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.greaterThanOrEqualTo(20)
        }
        
        self.view.addSubview(lockImageView)
        lockImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(thirdParagraphTitle.snp.top).offset(5)
            make.right.equalTo(thirdParagraphTitle.snp.left).offset(-30)
            make.height.lessThanOrEqualTo(60)
            make.width.lessThanOrEqualTo(60)
        }
        
        self.view.addSubview(thirdParagraph)
        thirdParagraph.snp.makeConstraints { (make) in
            make.top.equalTo(thirdParagraphTitle.snp.bottom).offset(3)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(-60)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.greaterThanOrEqualTo(20)
        }
        
        // Action button is enabled at all times.
        self.view.addSubview(actionButton)
        actionButton.isEnabled = true
        actionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(55)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-55)
            make.height.equalTo(50)
        }
        actionButton.addTarget(self, action: #selector(self.actionButtonPressed),
                               for: .touchUpInside)
    }
    
}


