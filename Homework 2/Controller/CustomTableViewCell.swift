//
//  CustomTableViewCell.swift
//  Homework 2
//
//  Created by Noah Korner on 4/6/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.cityImage.layer.cornerRadius = self.cityImage.frame.width / 2
    }
    
}
