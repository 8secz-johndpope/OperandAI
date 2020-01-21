//
//  UITableViewHelper.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-15.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Setup message view if tableview is empty
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        // A title label if needed.
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        titleLabel.text = title
        
        // Main message to user.
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .systemGray
        let customFont = interLightBeta(size: 18)
        messageLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        // Setup view.
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true

        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    /// Remove UIView if cells start appearing
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
