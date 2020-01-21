//
//  DashboardCell.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-29.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import UIKit

/// Dashboard Cell used to display metrics
class DashboardCell: BaseCell {
    
    /// Set the cell's content based off the message passed to the cell
    var message: DashData? {
        didSet {
            messageTextView.text = message?.text
            headerTextView.text = message?.header
            titleTextView.text = message?.title
        }
    }
    
    let headerTextView: UITextView = {
        let textView = UITextView()
        let customFont = interSemiBold(size: 14)
        textView.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "Sample message"
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        let customFont = interRegular(size: 20)
        textView.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "Sample message"
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        let customFont = interLightBeta(size: 16)
        textView.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "Sample message"
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .systemBackground
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(headerTextView)
        addSubview(titleTextView)
    }
}
