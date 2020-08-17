//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Sanika Pol on 8/15/20.
//  Copyright © 2020 Sanika Pol. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "WeatherCollectionViewCell"
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }
    
    func configure(with model: HourlyWeatherDetails) {
        self.tempLabel.text = "\(model.temp)"
        self.iconImageView.contentMode = .scaleAspectFit
        let icon = model.weather[0].description

        if icon.elementsEqual("clear sky") == true {
           self.iconImageView.image = UIImage(named: "clear")
        }
        else if icon.contains("snow"){
           self.iconImageView.image = UIImage(named: "snow")
        }
        else if icon.contains("clouds"){
           self.iconImageView.image = UIImage(named: "cloud")
        }
        else if icon.contains("mist"){
           self.iconImageView.image = UIImage(named: "mist")
        }
        else if icon.contains("rain"){
           self.iconImageView.image = UIImage(named: "rain")
        }
        else if icon.contains("thunderstrom"){
           self.iconImageView.image = UIImage(named: "thunderstrom")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
