//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Sanika Pol on 8/12/20.
//  Copyright © 2020 Sanika Pol. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: DailyWeatherDetails) {
        self.maxTempLabel.textAlignment = .center
        self.minTempLabel.textAlignment = .center
        self.minTempLabel.text = "\(Int(model.temp.min))°"
        self.maxTempLabel.text = "\(Int(model.temp.max))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
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
        
        /*guard
            let url = URL(string: "http://openweathermap.org/img/wn/\(model.weather[0].icon)@2x.png"),
            ((try? Data(contentsOf: url)) != nil)
            else {return}
        downloadImage(from: url)*/
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }
    
    /*func downloadImage(from url: URL) {
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.iconImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }*/
    
    
}
