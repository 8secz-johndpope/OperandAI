//
//  LeadingIconAndLabelTableCell.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-29.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import SnapKit
import UIKit

class LeadingIconAndLabelTableCell: UITableViewCell {
    
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
    
    let serviceIcon: UIImageView = UIImageView(image: UIImage(systemName: "dollarsign.circle"))
    
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
        
        backdrop.addSubview(serviceIcon)
        serviceIcon.snp.makeConstraints { (make) in
            make.left.equalTo(backdrop.snp.left)
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.centerY.equalTo(backdrop)
        }
        
        backdrop.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(serviceIcon.snp.right).offset(15)
            make.height.equalTo(backdrop.snp.height)
        }
        
    }
    
}
