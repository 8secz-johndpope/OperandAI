//
//  TransactionTableViewCell.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-29.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    // MARK: Variables
    
    lazy var backView: UIView = {
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let view = UIView(frame: CGRect(x: 15, y: 5, width: screenWidth - 30, height: 55))
        view.backgroundColor = UIColor.systemBackground
        return view
    }()
    
    lazy var pending: UILabel = {
        let customFont = interBold(size: 15)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 15, height: 47))
        label.textAlignment = .center
        label.font = customFont
        label.numberOfLines = 0
        return label
    }()
    
    lazy var arrowImage: UILabel = {
        let customFont = interSemiBold(size: 15)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: (screenWidth - 30) * 0.6 - 15, height: 55))
        label.textAlignment = .left
        label.font = customFont
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let customFont = interRegular(size: 18)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: (screenWidth - 30) * 0.6, y: 5, width: (screenWidth - 30) * 0.4 - 10, height: 25))
        label.textAlignment = .right
        label.font = customFont
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let customFont = interLightBeta(size: 17)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let label = UILabel(frame: CGRect(x: (screenWidth - 30) * 0.6, y: 30, width: (screenWidth - 30) * 0.4 - 10, height: 25))
        label.textAlignment = .right
        label.font = customFont
        return label
    }()
    
    // MARK: Override Functions
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(pending)
        backView.addSubview(arrowImage)
        backView.addSubview(nameLabel)
        backView.addSubview(amountLabel)
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 7
        backView.clipsToBounds = true
        pending.clipsToBounds = true
        arrowImage.clipsToBounds = true
    }
    
}
