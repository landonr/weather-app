//
//  ViewController.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import UIKit

class ViewController: UIViewController {
    private let manager = WeatherManager()
    
    @IBOutlet weak var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(manager.getWeatherData(woeid: 4418))
        // Do any additional setup after loading the view.
    }
}

class WeatherDataCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var imageView: UIImageView?
     @IBOutlet weak var temperatureLabel: UILabel?
     @IBOutlet weak var lowTemperatureLabel: UILabel?
     @IBOutlet weak var highTemperatureLabel: UILabel?
     @IBOutlet weak var weatherStateLabel: UILabel?
     
     func configure(_ data: ConsolidatedWeather) {
          temperatureLabel?.text = "\(data.theTemp)"
          lowTemperatureLabel?.text = "\(data.minTemp)"
          highTemperatureLabel?.text = "\(data.maxTemp)"
          weatherStateLabel?.text = "\(data.weatherStateName)"
     }
}
