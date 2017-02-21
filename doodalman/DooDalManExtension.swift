//
//  DooDalManExtension.swift
//  doodalman
//
//  Created by mac on 2017. 2. 21..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func withPadding() -> UIView{
//        self.bounds = CGRectInset(self.frame, 10.0, 10.0);
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))

        container.addSubview(self)

        return container
        
    }
}
