//
//  SearchresultTableViewCell.swift
//  Watchlist
//
//  Created by Jasper Scholten on 25-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class SearchresultTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePosterSearch: UIImageView!
    @IBOutlet weak var movieTitleSearch: UILabel!
    @IBOutlet weak var movieYearSearch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
