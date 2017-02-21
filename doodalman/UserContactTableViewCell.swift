//
//  UserContactTableViewCell.swift
//  doodalman
//
//  Created by mac on 2017. 2. 22..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class UserContactTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var lastChatContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
