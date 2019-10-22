//
//  MovieCell.swift
//  Flixster
//
//  Created by William Huynh on 10/14/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
