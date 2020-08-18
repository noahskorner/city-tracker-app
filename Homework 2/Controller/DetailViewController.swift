//
//  DetailViewController.swift
//  Homework 2
//
//  Created by Noah Korner on 4/6/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    var selectedCity:cityObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cityLabel.text = selectedCity?.cityName
        self.cityImage.image = selectedCity?.cityImage
        self.descLabel.text = selectedCity?.cityDescription
        self.cityImage.layer.cornerRadius = 25
    }
}
