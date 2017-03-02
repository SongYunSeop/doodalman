//
//  ChatTableViewCell.swift
//  doodalman
//
//  Created by mac on 2017. 2. 17..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentTextView: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentTextView.layer.cornerRadius = 8.0
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   

}
