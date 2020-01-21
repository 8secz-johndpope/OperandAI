//
//  TwoMainLabelTableCell.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-29.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import UIKit

class TwoMainLabelTableCell: UITableViewCell {
    
    // MARK: UITableViewCell Required
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    /// Something Xcode complains about
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Variables
    
    let backdrop: UIView = UIView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        let customFont = interLightBeta(size: 16)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        label.text = "Sample Item Financials"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        let customFont = interLightBeta(size: 16)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        label.text = "Nirosh Ratnarajah"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Setup
    
    /// Setup our setting cells
    func setupViews() {
        
        contentView.addSubview(backdrop)
        backdrop.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(25)
            make.bottom.equalTo(contentView.snp_bottomMargin)
            make.top.equalTo(contentView.snp_topMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.left.equalTo(contentView.snp_leftMargin)
        }
        
        backdrop.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backdrop.snp.left)
            make.height.equalTo(backdrop.snp.height)
            make.width.equalTo(backdrop.snp.width).dividedBy(2).offset(-5)
        }
        
        backdrop.addSubview(secondaryLabel)
        secondaryLabel.snp.makeConstraints { (make) in
            make.right.equalTo(backdrop.snp.right)
            make.height.equalTo(backdrop.snp.height)
            make.left.equalTo(nameLabel.snp.right).offset(10)
        }
        
    }
    
}
