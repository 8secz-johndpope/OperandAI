//
//  UIElements.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-21.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation
import UIKit

/// Class derived from UIButton to create special all contrast to user background button
class BlackButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.secondarySystemBackground : UIColor.label
        }
    }
}

/// Class derived from UIButton to create a voice recognition button
class VoiceSendButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? UIColor.secondaryLabel : .tertiaryLabel
        }
    }
}

/// Class derived from UIButton to create a voice recognition button after recording finishes
class VoiceEndButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? UIColor.secondaryLabel : .red
        }
    }
}

/// Class derived from UIButton to create a message send button
class TextSendButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 0.90) : UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 0.98)
        }
    }
}

/// Creates a title label for a view
func createTitleLabel(text: String, textSize: CGFloat, numberOfLines: Int) -> UILabel {
    let customFont = interRegular(size: textSize)
    let label = UILabel()
    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    label.textColor = .label
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = numberOfLines
    label.textAlignment = .center
    label.text = text
    return label
}

/// Create a textfield that is rounded on all four sides
func createTextField_WellRounded(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> UITextField {
    let customFont = interLightBeta(size: textSize)
    let textField = UITextField()
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.spellCheckingType = .no
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 7
    textField.tag = tag
    
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
    textField.leftViewMode = .always
    
    textField.backgroundColor = .secondarySystemGroupedBackground
    textField.font = UIFontMetrics.default.scaledFont(for: customFont)
    textField.adjustsFontForContentSizeCategory = true
    textField.textColor = .label
    textField.accessibilityIdentifier = identifier
    textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
    return textField
}

/// Creates a textfield, rounded only on the top
func createTextField_Top(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> UITextField {
    let customFont = interLightBeta(size: textSize)
    let textField = UITextField()
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.spellCheckingType = .no
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 7
    textField.tag = tag
    
    textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
    textField.leftViewMode = .always
    
    textField.backgroundColor = .secondarySystemGroupedBackground
    textField.font = UIFontMetrics.default.scaledFont(for: customFont)
    textField.adjustsFontForContentSizeCategory = true
    textField.textColor = .label
    textField.accessibilityIdentifier = identifier
    textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
    return textField
}

/// Creates a textfield, no rounded applied (intended to be sandwiched by other textfields
func createTextField_Middle(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> UITextField {
    let customFont = interLightBeta(size: textSize)
    let textField = UITextField()
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.spellCheckingType = .no
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 0
    textField.tag = tag
    
    textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
    textField.leftViewMode = .always
    
    textField.backgroundColor = .secondarySystemGroupedBackground
    textField.font = UIFontMetrics.default.scaledFont(for: customFont)
    textField.adjustsFontForContentSizeCategory = true
    textField.textColor = .label
    textField.accessibilityIdentifier = identifier
    textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
    return textField
}

/// Creates a textfield, rounded only on the botton
func createTextField_Bottom(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> UITextField {
    let customFont = interLightBeta(size: textSize)
    let textField = UITextField()
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.spellCheckingType = .no
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 7
    textField.tag = tag
    
    textField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
    textField.leftViewMode = .always
    
    textField.backgroundColor = .secondarySystemGroupedBackground
    textField.font = UIFontMetrics.default.scaledFont(for: customFont)
    textField.adjustsFontForContentSizeCategory = true
    textField.textColor = .label
    textField.accessibilityIdentifier = identifier
    textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
    return textField
}

/// Creates a password textfield, no rounded (intended to be sandwiched)
//    func createPasswordTextField_Middle(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> PasswordTextField {
//        let customFont = interLightBeta(size: textSize)
//        let textField = PasswordTextField()
//        textField.autocorrectionType = .no
//        textField.autocapitalizationType = .none
//        textField.spellCheckingType = .no
//        textField.layer.masksToBounds = true
//        textField.isSecureTextEntry = true
//        textField.layer.cornerRadius = 0
//        textField.tag = tag
//
//        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
//        textField.leftViewMode = .always
//
//        textField.backgroundColor = .secondarySystemGroupedBackground
//        textField.font = UIFontMetrics.default.scaledFont(for: customFont)
//        textField.adjustsFontForContentSizeCategory = true
//        textField.textColor = .label
//        textField.accessibilityIdentifier = identifier
//        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
//        return textField
//    }

/// Creates a password textfield, no rounded (intended to be sandwiched)
//    func createPasswordTextField_Top(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> PasswordTextField {
//        let customFont = interLightBeta(size: textSize)
//        let textField = PasswordTextField()
//        textField.autocorrectionType = .no
//        textField.autocapitalizationType = .none
//        textField.spellCheckingType = .no
//        textField.layer.masksToBounds = true
//        textField.isSecureTextEntry = true
//        textField.layer.cornerRadius = 7
//        textField.tag = tag
//
//        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
//        textField.leftViewMode = .always
//
//        textField.backgroundColor = .secondarySystemGroupedBackground
//        textField.font = UIFontMetrics.default.scaledFont(for: customFont)
//        textField.adjustsFontForContentSizeCategory = true
//        textField.textColor = .label
//        textField.accessibilityIdentifier = identifier
//        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
//        return textField
//    }

/// Creates a password text field rounded on the bottom
//    func createPasswordTextField_Bottom(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> PasswordTextField {
//        let customFont = interLightBeta(size: textSize)
//        let textField = PasswordTextField()
//        textField.autocorrectionType = .no
//        textField.autocapitalizationType = .none
//        textField.spellCheckingType = .no
//        textField.layer.masksToBounds = true
//        textField.isSecureTextEntry = true
//        textField.layer.cornerRadius = 7
//        textField.tag = tag
//
//        textField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
//        textField.leftViewMode = .always
//
//        textField.backgroundColor = .secondarySystemGroupedBackground
//        textField.font = UIFontMetrics.default.scaledFont(for: customFont)
//        textField.adjustsFontForContentSizeCategory = true
//        textField.textColor = .label
//        textField.accessibilityIdentifier = identifier
//        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
//        return textField
//    }

/// Creates a password textfield, no rounded (intended to be sandwiched)
//    func createPasswordTextField_WellRounded(textSize: CGFloat, tag: Int, placeholder:String, identifier: String) -> PasswordTextField {
//        let customFont = interLightBeta(size: textSize)
//        let textField = PasswordTextField()
//        textField.autocorrectionType = .no
//        textField.autocapitalizationType = .none
//        textField.spellCheckingType = .no
//        textField.layer.masksToBounds = true
//        textField.isSecureTextEntry = true
//        textField.layer.cornerRadius = 7
//        textField.tag = tag
//
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
//        textField.leftViewMode = .always
//
//        textField.backgroundColor = .secondarySystemGroupedBackground
//        textField.font = UIFontMetrics.default.scaledFont(for: customFont)
//        textField.adjustsFontForContentSizeCategory = true
//        textField.textColor = .label
//        textField.accessibilityIdentifier = identifier
//        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
//        return textField
//    }

/// Creates the Nameless black button, intended for situations where the context of the button can be implied
func createBlackButton(identifier: String) -> BlackButton {
    let button = BlackButton()
    button.backgroundColor = UIColor.label
    button.layer.cornerRadius = 7
    button.clipsToBounds = true
    button.isUserInteractionEnabled = true
    button.accessibilityIdentifier = identifier
    return button
}

/// Creates a blue button for small actions
func createBlueButton(textSize: CGFloat, text: String, identifier: String) -> UIButton {
    let customFont = interLightBeta(size: textSize)
    let button = UIButton()
    button.accessibilityIdentifier = identifier
    button.setTitle(text, for: .normal)
    button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
    button.titleLabel?.textAlignment = NSTextAlignment.center
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .highlighted)
    button.isUserInteractionEnabled = true
    return button
}

/// Creates a red button for critical actions
func createRedButton(textSize: CGFloat, text: String, identifier: String) -> UIButton {
    let customFont = interLightBeta(size: textSize)
    let button = UIButton()
    button.accessibilityIdentifier = identifier
    button.setTitle(text, for: .normal)
    button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
    button.titleLabel?.textAlignment = NSTextAlignment.center
    button.setTitleColor(UIColor.systemRed, for: .normal)
    button.setTitleColor(UIColor.systemRed.withAlphaComponent(0.5), for: .highlighted)
    button.isUserInteractionEnabled = true
    return button
}

/// Creates a custom title
func createOnboardingTitle(font: UIFont, text: String) -> UILabel {
    let customFont = font
    let label = UILabel()
    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    label.textColor = .label
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.textAlignment = .left
    label.text = text
    return label
}

// Creates a smaller title
func createOnboardingParagraphTitle(text: String) -> UILabel {
    let customFont = interSemiBold(size: 17)
    let label = UILabel()
    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    label.textColor = .label
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.textAlignment = .left
    label.text = text
    return label
}

/// Creates a paragraph
func createOnboardingParagraph(text: String) -> UILabel {
    let customFont = interLightBeta(size: 15)
    let label = UILabel()
    label.font = UIFontMetrics.default.scaledFont(for: customFont)
    label.textColor = .label
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.textAlignment = .left
    label.text = text
    return label
}

/// Returns image view
func loadImageView(imageName: String) -> UIImageView {
    let image = UIImageView()
    image.image = UIImage(named: imageName)
    image.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
    return image
}
