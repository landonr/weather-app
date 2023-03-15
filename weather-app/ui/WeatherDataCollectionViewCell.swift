//
//  WeatherDataCollectionViewCell.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import UIKit

class WeatherDataCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var imageView: UIImageView?
     @IBOutlet weak var temperatureLabel: UILabel?
     @IBOutlet weak var lowTemperatureLabel: UILabel?
     @IBOutlet weak var highTemperatureLabel: UILabel?
     @IBOutlet weak var weatherStateLabel: UILabel?
     
     func configure(_ data: ConsolidatedWeather) {
         temperatureLabel?.text = "\(data.theTemp.asCelcius)"
         lowTemperatureLabel?.text = String(
            format: NSLocalizedString("tempMin",
                                      comment: "Low temperature"),
            "\(data.minTemp.asCelcius)"
         )
         highTemperatureLabel?.text = String(
            format: NSLocalizedString("tempMax",
                                      comment: "Max temperature"),
            "\(data.maxTemp.asCelcius)"
         )
         weatherStateLabel?.text = "\(data.weatherStateName)"
     }
}

private extension Double {
    var asCelcius: String {
        return "\(self.rounded())°"
    }

    var asFahrenheit: String {
        let celsius = Measurement(value: self, unit: UnitTemperature.celsius)
        let fahrenheit = celsius.converted(to: .fahrenheit).value
        return "\(fahrenheit.rounded())°F"
    }
}
