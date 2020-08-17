//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sanika Pol on 8/12/20.
//  Copyright © 2020 Sanika Pol. All rights reserved.
//

import UIKit
import CoreLocation
//For resume:
//Location : CoreLocation
//tableView
//custom cell: collection view
//API


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var table: UITableView!
    var models = [DailyWeatherDetails]()
    var hourlyModels = [HourlyWeatherDetails]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current: CurrentWeatherDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        //Register 2 table cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpLocation()
    }
    
    //Location
    
    //URL =
    
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty,currentLocation == nil{
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherLocation()
        }
    }
    
    func requestWeatherLocation() {
        guard currentLocation == currentLocation else{
            return
        }
    
        let lat = currentLocation?.coordinate.latitude
        let lng = currentLocation?.coordinate.longitude
        
        print("\(String(describing: lat)) | \(String(describing: lng))")
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=37.33233141&lon=-122.0312186&units=metric&exclude=minutely&appid=52701c996c4e6717939695e7d8756b67"
        
         URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }

            // Convert data to models/some object
            var json: WeatherDetails?
            do {
                json = try JSONDecoder().decode(WeatherDetails.self, from: data)
            }
            catch {
                print("error: \(error)")
            }

            guard let result = json else {
                return
            }
            
            //print(result.daily.count)
        
            let entries = result.daily

            self.models.append(contentsOf: entries)
            
            let current = result.current
            self.current = current
            
            self.hourlyModels = result.hourly
        
            DispatchQueue.main.async {
                self.table.reloadData()

                self.table.tableHeaderView = self.createTableHeader()
            }

            print(result.timezone)
            }).resume()
    }
    
    func createTableHeader() -> UIView {
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))

        headerVIew.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/2))

        headerVIew.addSubview(locationLabel)
        headerVIew.addSubview(tempLabel)
        headerVIew.addSubview(summaryLabel)

        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

        locationLabel.text = "Current Location"

        guard let currentWeather = self.current else {
                   return UIView()
        }

        tempLabel.text = "\(currentWeather.temp)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = self.current?.weather[0].description

        return headerVIew
    }
    

    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // 1 cell that is collectiontableviewcell
            return 1
        }
        // return models count
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for:indexPath) as! WeatherTableViewCell
        cell.configure(with: models [indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

struct WeatherDetails:Codable {
    let lat: Float
    let lon: Float
    let timezone: String
    let timezone_offset: Int
    let current:CurrentWeatherDetails
    let hourly:[HourlyWeatherDetails]
    let daily:[DailyWeatherDetails]
}

struct CurrentWeatherDetails:Codable {
    let dt: CLong
    let sunrise: CLong
    let sunset: CLong
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Float
    let wind_deg: Int
    let weather: [Weather]
}

struct HourlyWeatherDetails:Codable{
    let dt: CLong
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Float
    let wind_deg: Int
    let weather: [Weather]
}


struct DailyWeatherDetails:Codable {
    let dt: CLong
    let sunrise: CLong
    let sunset: CLong
    let temp: Temp
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let wind_speed: Float
    let wind_deg: Int
    let weather: [Weather]
}

struct Weather:Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp:Codable {
    let day: Float
    let min: Float
    let max: Float
    let night: Float
    let eve: Float
    let morn: Float
}

struct FeelsLike:Codable{
    let day: Float
    let night: Float
    let eve: Float
    let morn: Float
}


