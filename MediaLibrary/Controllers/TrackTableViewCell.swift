//
//  TrackTableViewCell.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 11.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!

    var track: Track? {
        didSet {
            titleLabel.text = track?.trackTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
