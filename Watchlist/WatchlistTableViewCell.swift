//
//  WatchlistTableViewCell.swift
//  Watchlist
//
//  Created by Jasper Scholten on 25-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePosterList: UIImageView!
    @IBOutlet weak var movieTitleList: UILabel!
    @IBOutlet weak var movieYearList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
