//
//  MemberTableViewCell.swift
//  Sets up the custom table view cell in MembersTableViewController.
//  Features a name label that will be filled with the member's name 
//  and an image UIImageView that will be filled with the member's icon
//  url image.
//  DALIApp
//
//  Created by Sofia Stanescu-Bellu on 2/10/17.
//  Copyright © 2017 sofiastb. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    // Properties of the MemberTableViewCell
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
