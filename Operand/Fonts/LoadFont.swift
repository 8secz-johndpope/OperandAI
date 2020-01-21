//
//  LoadFont.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-21.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import Foundation
import UIKit

/// Family: Inter Font names: ["Inter-LightBETA", "Inter-Bold", "Inter-ExtraBoldItalic", "Inter-MediumItalic", "Inter-Medium", "Inter-ExtraLightItalicBETA", "Inter-ThinItalicBETA", "Inter-ExtraBold", "Inter-ExtraLightBETA", "Inter-BoldItalic", "Inter-Black", "Inter-Italic", "Inter-SemiBold", "Inter-SemiBoldItalic", "Inter-BlackItalic", "Inter-Regular"]

func interBold(size: CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "Inter-Bold", size: size) else {
        fatalError("Failed to load the \"Inter-Bold\" font.")
    }
    return customFont
}

func interRegular(size: CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "Inter-Regular", size: size) else {
        fatalError("Failed to load the \"Inter-Regular\" font.")
    }
    return customFont
}

func interLightBeta(size: CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "Inter-LightBETA", size: size) else {
        fatalError("Failed to load the \"Inter-LightBETA\" font.")
    }
    return customFont
}

func interSemiBold(size: CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "Inter-SemiBold", size: size) else {
        fatalError("Failed to load the \"Inter-SemiBold\" font.")
    }
    return customFont
}

func interExtraLightBeta(size: CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "Inter-ExtraLightBETA", size: size) else {
        fatalError("Failed to load the \"Inter-ExtraLightBETA\" font.")
    }
    return customFont
}
