//
//  MoviesTableViewCell.swift
//  xy-inc
//
//  Created by Luan Damasceno on 21/05/16.
//  Copyright © 2016 luan. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
