//
//  BaseCollectionViewCell.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-05.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .red
    }
}
