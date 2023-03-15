//
//  WeatherManager.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import Foundation
import UIKit

protocol IWeatherService {
    func getWeatherData(woeid: Int) -> WeatherData?
    func getWeatherStateImage(stateAbbr: String) -> UIImage
}

class FileWeatherService: IWeatherService {
    private let decoder = JSONDecoder()

    func getWeatherData(woeid: Int) -> WeatherData? {
        if let path = Bundle.main.url(forResource: "\(woeid)", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path, options: .mappedIfSafe)
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                return weatherData
            } catch {
                print("error: \(error)")
            }
        }
        return nil
    }
    
    func getWeatherStateImage(stateAbbr: String) -> UIImage {
        return UIImage()
    }
}

protocol IWeatherManager {
    var service: IWeatherService { get }
    func getWeatherData(woeid: Int) -> WeatherData?
    func getWeatherStateImage(stateAbbr: String) -> UIImage
}

class WeatherManager: IWeatherManager {
    var service: IWeatherService = FileWeatherService()
    
    func getWeatherData(woeid: Int) -> WeatherData? {
        return service.getWeatherData(woeid: woeid)
    }
    
    func getWeatherStateImage(stateAbbr: String) -> UIImage {
        return service.getWeatherStateImage(stateAbbr: stateAbbr)
    }
    
    
}
