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


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        print("Taeta")
//        if view.isedit
        view.endEditing(true)
    }
}


extension UIImage {
    func resize(size: CGSize) -> UIImage {
        let originSize = self.size
        
        let widthRatio = size.width / originSize.width
        let heightRatio = size.height / originSize.height
        
        var newSize: CGSize
        
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: originSize.width * heightRatio, height: originSize.height * heightRatio)

        } else {
            newSize = CGSize(width: originSize.height * heightRatio, height: originSize.height * heightRatio)

        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
