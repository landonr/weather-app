//
//  ViewController.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import UIKit

class ViewController: UIViewController {
    private let manager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(manager.getWeatherData(woeid: 4418))
        // Do any additional setup after loading the view.
    }
}
