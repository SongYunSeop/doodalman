//
//  ChatTableViewCell.swift
//  doodalman
//
//  Created by mac on 2017. 2. 17..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSize() {
        contentTextView.layer.cornerRadius = 12.0

        let fixedWidth = self.contentTextView.frame.size.width
        self.contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = self.contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        var newFrame = self.contentTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.contentTextView.frame = newFrame;
        
        var cellFrame = self.frame
        cellFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + 8.0 )
        self.frame = cellFrame
        //        self.frame

    }

}
