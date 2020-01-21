//
//  LiabilitiesTableViewCell.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-29.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import UIKit

class LiabilitiesTableViewCell: UITableViewCell {
    
    // MARK: Variables
    
    lazy var backView: UIView = {
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let view = UIView(frame: CGRect(x: 15, y: 10, width: screenWidth - 30, height: 225))
        view.backgroundColor = UIColor.systemBackground
        return view
    }()
    
    lazy var accountLabel: UILabel = {
        let customFont = interRegular(size: 32)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: (screenWidth - 30) * 0.85 - 15, height: 55))
        label.textAlignment = .left
        label.font = customFont
        label.numberOfLines = 0
        return label
    }()
    
    lazy var currencyLabel: UILabel = {
        let customFont = interLightBeta(size: 18)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: (screenWidth - 30) * 0.80, y: 15, width: (screenWidth - 30) * 0.20 - 15, height: 25))
        label.textAlignment = .right
        label.font = customFont
        return label
    }()
    
    lazy var institutionMaskLabel: UILabel = {
        let customFont = interLightBeta(size: 17)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: 15, y: 55, width: (screenWidth - 30) - 30, height: 30))
        label.textAlignment = .left
        label.font = customFont
        return label
    }()
    
    lazy var totalBalanceLabel: UILabel = {
        let customFont = interLightBeta(size: 30)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: 15, y: 105, width: (screenWidth - 30) - 30, height: 30))
        label.textAlignment = .left
        label.font = customFont
        label.text = "Total Balance"
        return label
    }()
    
    lazy var availableLabel: UILabel = {
        let customFont = interSemiBold(size: 40)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: 15, y: 135, width: (screenWidth - 30) - 30, height: 50))
        label.textAlignment = .left
        label.font = customFont
        return label
    }()
    
    lazy var limitLabel: UILabel = {
        let customFont = interLightBeta(size: 20)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: 15, y: 185, width: (screenWidth - 30) - 30, height: 30))
        label.textAlignment = .left
        label.font = customFont
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: Override Functions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(accountLabel)
        backView.addSubview(currencyLabel)
        backView.addSubview(institutionMaskLabel)
        backView.addSubview(totalBalanceLabel)
        backView.addSubview(availableLabel)
        backView.addSubview(limitLabel)
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 7
        backView.clipsToBounds = true
        accountLabel.clipsToBounds = true
    }
    
}
