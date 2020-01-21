//
//  ChatLogMessageCell.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-29.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import UIKit

/// Operand Chat message cell
class ChatLogMessageCell: BaseCell {
    
    /// Set the cell's content based off the message passed to the cell
    var message: Message? {
        didSet {
            messageTextView.text = message?.text
        }
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        let customFont = interLightBeta(size: 16)
        textView.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "Sample message"
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
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
        addSubview(profileImageView)
    }
}
