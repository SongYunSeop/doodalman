//
//  RoomListTableViewCell.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class RoomListTableViewCell: UITableViewCell {

    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var roomThumbnail: UIImageView!    
    @IBOutlet weak var roomAddresss: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var roomDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
