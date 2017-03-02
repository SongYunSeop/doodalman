//
//  PaddingLabel.swift
//  doodalman
//
//  Created by mac on 2017. 2. 25..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)))
    }
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += 12
        intrinsicSuperViewContentSize.width += 16
        return intrinsicSuperViewContentSize
    }
}
